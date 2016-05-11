//
//  BaseMenuViewController.swift
//  DoctorApp
//
//  Created by Edward Nguyen on 4/30/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit
import Spring
import RealmSwift

typealias repeatDateTag = repeatDate

enum AddClinicTimingType {
    case AddTimeSlot
    case EditTimeSlot
}

protocol AddClinicTimingViewDelegate {
    func addClinicTimingViewDidConfirm()
    func addClinicTimingViewDidClose()
}

class AddClinicTimingView: UIView {
    // Test
    @IBOutlet var lb_clinicName: UILabel!
    @IBOutlet private var tv_addClinicTiming: UITableView!
    @IBOutlet var view: SpringView!
    //--------
//    @IBOutlet var a_repeatDateButtons: Array<UIButton>!
    //---
    var delegate: AddClinicTimingViewDelegate!
    //--
    private var ma_ClinicTiming = Array<ClinicTiming>()
    var mClinicTiming: ClinicTiming!
    var ma_Timing = Array<MMTiming>()
    var mEditingTiming: MMTiming?
//    var repeatDates = [String]()
    //------
    var screenType = AddClinicTimingType.AddTimeSlot
    
    @IBOutlet private var v_timePicker: TimePicker!
    private var v_dataPicker: DataPicker!
    private var a_data: Array<String>!
    //--
    var idxObjectChange: Int = -1
    var idxTypeChange: Int = -1
    //---
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        //---
        NSBundle.mainBundle().loadNibNamed("AddClinicTimingView", owner: self, options: nil)
        //---
        self.view.frame = CGRectMake(0, 0, self.frame.width, self.frame.height)
        //---
        self.addSubview(self.view)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //---
        NSBundle.mainBundle().loadNibNamed("AddClinicTimingView", owner: self, options: nil)
        //---
        self.view.frame = CGRectMake(0, 0, frame.width, frame.height)
        //---
        self.addSubview(self.view)
        //---
        configureTableView()
        
        v_timePicker = TimePicker(frame: CGRectMake(0, UIScreen.mainScreen().bounds.height, UIScreen.mainScreen().bounds.width, 300))
        //---
//        Utils.invokeLater {
//            self.btnAddNewBlockPressed(nil)
//        }
    }
    
    convenience init(type: AddClinicTimingType, clinicId: Int, frame: CGRect){
        self.init(frame: frame)
//        mClinicTiming = clinicTiming
        screenType = type
//        repeatDates = [dayOfWeek]
//        reloadDateButtons()
    }
    
    convenience init(type: AddClinicTimingType, timing: MMTiming, clinicTiming: ClinicTiming, frame: CGRect){
        self.init(frame: frame)
        screenType = type
        //-----
        mClinicTiming = clinicTiming
        mEditingTiming = timing
//        repeatDates = mEditingTiming!.mt_repeatDate
//        reloadDateButtons()
    }
    
}

extension AddClinicTimingView {
    @IBAction func cancelClicked(sender: UIButton) {
        delegate.addClinicTimingViewDidClose()
    }
    
    @IBAction func confirmClicked(sender: UIButton) {
        self.endEditing(true)
        //-------
        
        ma_ClinicTiming = Array<ClinicTiming>()

    }
    

    
    func btnAddNewBlockPressed(sender: AnyObject?){
        //------------
//        if screenType == .AddTimeSlot {
//            let timing = MMTiming.mt_addNew(mClinicTiming)
//            ma_Timing.append(timing)
//            tv_addClinicTiming.insertRowsAtIndexPaths([NSIndexPath(forRow: ma_Timing.count-1, inSection: 0)], withRowAnimation: .Automatic)
//        }
    }
    
    
    func showTimePicker(textField: UITextField){
        v_timePicker.currentTextField = textField
        textField.inputView = v_timePicker
        v_timePicker.delegate = self
    }
    
    func showDataPicker(textField: UITextField){
        if v_dataPicker == nil {
            v_dataPicker = DataPicker(frame: CGRectMake(0, UIScreen.mainScreen().bounds.height - 300, UIScreen.mainScreen().bounds.width, 300))
        }
        v_dataPicker.setData(a_data)
        v_dataPicker.tf_current = textField
        textField.inputView = v_dataPicker
    }
    
}

//MARK: alert delegate
extension AddClinicTimingView: UIAlertViewDelegate{
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if (buttonIndex == 0) {
            self.tv_addClinicTiming.reloadData()
        }
    }

}

//MARK: UITableViewDelegate
extension AddClinicTimingView: UITableViewDelegate, UITableViewDataSource{
    func configureTableView() {
        tv_addClinicTiming.tableFooterView = UIView(frame: CGRectZero)
        tv_addClinicTiming.registerNib(UINib(nibName: "ClinicTimeSlotCell", bundle: nil), forCellReuseIdentifier: "ClinicTimeSlotCell")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if screenType == .AddTimeSlot{
            return ma_Timing.count + 1
        }
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ClinicTimeSlotCell", forIndexPath: indexPath) as! ClinicTimeSlotCell
        
        switch screenType{
        case .AddTimeSlot:
            cell.configureDefaultCell()
//            if indexPath.row < ma_Timing.count{
//                cell.configureDefaultCell()
//            }
//            else {
//                cell.configureAsAddNewCell()
//            }
            
            if ma_Timing.count > 0  && indexPath.row < ma_Timing.count{
                let timing = ma_Timing[indexPath.row]
                cell.tf_timefrom.text = timing.mt_timefrom
                cell.tf_timeto.text = timing.mt_timeto
                cell.tf_timeSlot.text = timing.mt_timeOfSlot > 0 ? "\(timing.mt_timeOfSlot)" : "15"
                cell.tf_patientSlot.text = timing.mt_patientPerSlot > 0 ? "\(timing.mt_patientPerSlot)" : "1"
            }

            break
        case .EditTimeSlot:
            cell.configureDefaultCell()
            cell.tf_timefrom.text = mEditingTiming?.mt_timefrom
            cell.tf_timeto.text = mEditingTiming?.mt_timeto
            cell.tf_timeSlot.text = String(mEditingTiming!.mt_timeOfSlot)
            cell.tf_patientSlot.text = String(mEditingTiming!.mt_patientPerSlot)
            break
        }
        
        //---
        cell.lb_numberSlot.text = "Slot \(indexPath.row + 1)"
        //--
        cell.tf_timefrom.tag = 4 * indexPath.row
        cell.tf_timefrom.delegate = self
        cell.tf_timeto.tag = 4 * indexPath.row + 1
        cell.tf_timeto.delegate = self
        cell.tf_timeSlot.tag = 4 * indexPath.row + 2
        cell.tf_timeSlot.delegate = self
        cell.tf_patientSlot.tag = 4 * indexPath.row + 3
        cell.tf_patientSlot.delegate = self
        //--
        cell.btn_addNewBlock.addTarget(self, action: #selector(AddClinicTimingView.btnAddNewBlockPressed(_:)), forControlEvents: .TouchUpInside)
//        cell.btn_deleteBlock.tag = indexPath.row
//        cell.btn_deleteBlock.addTarget(self, action: Selector("btnDeletePressed:"), forControlEvents: .TouchUpInside)
        return cell
        
    }
}

//MARK: text field delegate
extension AddClinicTimingView: UITextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField) {
        let index = textField.tag / 4
        let type = textField.tag % 4
        
        if (type < 2) {
            idxObjectChange = index
            idxTypeChange = type
            showTimePicker(textField)
        } else if type == 2 {
            a_data = ["5", "10", "15", "20", "30", "40", "50", "60", "90"]
            showDataPicker(textField)
        } else if type == 3 {
            a_data = ["1", "2", "3"]
            showDataPicker(textField)
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let type = textField.tag % 4
        
//        if (type >= 2){
//            if !string.isNumeric() {
//                return false
//            }
//        }
        return true
    }
}

//MARK: TimePickerDelegate
extension AddClinicTimingView : TimePickerDelegate{
    func pickerDidSelectTime(time: String){
//        switch screenType{
//        case .AddTimeSlot:
//            if idxTypeChange == 0 {
//                ma_Timing[idxObjectChange].mt_editTimeFrom(time)
//                
//            } else if idxTypeChange == 1 {
//                ma_Timing[idxObjectChange].mt_editTimeTo(time)
//            }
//            break
//        case .EditTimeSlot:
//            if idxTypeChange == 0 {
//                mEditingTiming?.mt_editTimeFrom(time)
//                
//            } else if idxTypeChange == 1 {
//                mEditingTiming?.mt_editTimeTo(time)
//            }
//            break
//        }
        
        
    }
}

//MARK: Time picker
extension AddClinicTimingView{
    func showTimePicker() {
        if self.v_timePicker == nil {
            self.v_timePicker = TimePicker(frame: CGRectMake(0, UIScreen.mainScreen().bounds.height - 300, self.view.bounds.width, 300))
        }
    }
    
    func hideTimePicker(){
        UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.v_timePicker.frame = CGRectMake(0.0, UIScreen.mainScreen().bounds.height, 1024, 300)
            }, completion: { finished in
                self.v_timePicker.hidden = true
        })
    }
}

//extension Array{
//    mutating func removeValue (value: String){
//        for (var i = 0 ; i < self.count ; i++){
//            if self[i] as! String == value{
//                 self.removeAtIndex(i)
//            }
//        }
//    }
//}
