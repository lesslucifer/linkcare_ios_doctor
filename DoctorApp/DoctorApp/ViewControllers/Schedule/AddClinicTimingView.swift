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

    var ma_Timing = Array<Timings>()
    var mEditingTiming: Timings?
    var clinicId: Int = 0
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
    }
    
    convenience init(type: AddClinicTimingType, clinicId: Int, frame: CGRect){
        self.init(frame: frame)
        screenType = type
        self.clinicId = clinicId
    }
    
    convenience init(type: AddClinicTimingType, timing: Timings, clinicId: Int, frame: CGRect){
        self.init(frame: frame)
        screenType = type
        //-----
        mEditingTiming = timing
        self.clinicId = clinicId
    }
    
}

extension AddClinicTimingView {
    @IBAction func cancelClicked(sender: UIButton) {
        delegate.addClinicTimingViewDidClose()
    }
    
    @IBAction func confirmClicked(sender: UIButton) {
        self.endEditing(true)
        
        if (screenType == .EditTimeSlot){
            let cell = self.tv_addClinicTiming.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! ClinicTimeSlotCell
            
            if cell.tf_timeto.text == "00:00" {
                cell.tf_timeto.text = "24:00"
            }
            
            let beginTime = Utils.converStringTimeToInt(cell.tf_timefrom.text!)
            let endTime = Utils.converStringTimeToInt(cell.tf_timeto.text!)
            var lengthTime = endTime - beginTime
            
//            lengthTime = lengthTime < 0 ? lengthTime + 60 * 24 : lengthTime
            
            if lengthTime < 0 {
                Utils.showAlertWithError("thời gian không hợp lệ")
            } else {
                mEditingTiming?.editTimeFrom(beginTime)
                mEditingTiming?.lengthTime(lengthTime)
                self.delegate.addClinicTimingViewDidConfirm()
            }
        } else {
            for (var i = 0 ; i < ma_Timing.count ; i += 1){
                let cell = self.tv_addClinicTiming.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as! ClinicTimeSlotCell
                if cell.tf_timeto.text == "00:00" {
                    cell.tf_timeto.text = "24:00"
                }
                
                let beginTime = Utils.converStringTimeToInt(cell.tf_timefrom.text!)
                let endTime = Utils.converStringTimeToInt(cell.tf_timeto.text!)
                var lengthTime = endTime - beginTime
                
                if lengthTime < 0 {
                    Utils.showAlertWithError("thời gian không hợp lệ")
                } else {
                    ma_Timing[i].editTimeFrom(beginTime)
                    ma_Timing[i].lengthTime(lengthTime)
                    ma_Timing[i].addType(self.clinicId)
                    self.delegate.addClinicTimingViewDidConfirm()
                }
            }
            
        }
        
    }
    
    func btnAddNewBlockPressed(sender: AnyObject?){
        let newTimming = Timings(type: self.clinicId)
        let timing = Timings.addNew(newTimming)
        ma_Timing.append(timing)
        print(timing)
        tv_addClinicTiming.insertRowsAtIndexPaths([NSIndexPath(forRow: ma_Timing.count-1, inSection: 0)], withRowAnimation: .Automatic)
        
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
            if indexPath.row < ma_Timing.count{
                cell.configureDefaultCell()
            }
            else {
                cell.configureAsAddNewCell()
            }
            
            if ma_Timing.count > 0  && indexPath.row < ma_Timing.count{
                let timing = ma_Timing[indexPath.row]
                cell.tf_timefrom.text = Utils.converTimetoString(timing.beginTime)
                cell.tf_timeto.text = Utils.converTimetoString(timing.endTime)
            }

            break
        case .EditTimeSlot:
            cell.configureDefaultCell()
            cell.tf_timefrom.text = Utils.converTimetoString(mEditingTiming!.beginTime)
            cell.tf_timeto.text = Utils.converTimetoString(mEditingTiming!.endTime)
            break
        }
        
        //---
        cell.lb_numberSlot.text = "Slot \(indexPath.row + 1)"
        //--
        cell.tf_timefrom.tag = 4 * indexPath.row
        cell.tf_timefrom.delegate = self
        cell.tf_timeto.tag = 4 * indexPath.row + 1
        cell.tf_timeto.delegate = self
        
        if self.clinicId == 0 {
            cell.lbTimeSlot.text = "10"
        } else {
            cell.lbTimeSlot.text = "30"
        }
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
            a_data = ["5", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55", "60"]
            showDataPicker(textField)
        } else if type == 3 {
            a_data = ["1", "2", "3"]
            showDataPicker(textField)
        }
    }
    
}

//MARK: TimePickerDelegate
extension AddClinicTimingView : TimePickerDelegate{
    func pickerDidSelectTime(time: String){
        
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

