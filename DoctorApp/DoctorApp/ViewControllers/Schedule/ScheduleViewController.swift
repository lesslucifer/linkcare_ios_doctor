//
//  BaseMenuViewController.swift
//  DoctorApp
//
//  Created by Edward Nguyen on 4/30/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit
import Spring

enum DefineClinic{
    case Normal
    case TimeSlot
    case WalkingSlot
}

class ScheduleViewController: BaseMenuViewController {
    @IBOutlet private var tv_clinicTiming: UITableView!
    @IBOutlet var v_popupOverlay: UIView!
    @IBOutlet var btn_defTimeSlot: UIButton!
    @IBOutlet var lb_messageTap: UILabel!
    //---
    private var v_addClinicTiming: AddClinicTimingView!

    var tapAction = DefineClinic.Normal
    //---
    @IBOutlet private var v_timePicker: TimePicker!
    //----
    var ma_clinicTimings: Array<ClinicTiming>?
    var ma_timingTemps: Array<MMTimingTemp>?
    var ma_walkinTiming = Array<MMTiming>()
    
    //---
    let panRec = UIPanGestureRecognizer()
    var originalLocation: CGPoint!
    var originalContentOrigin: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //---
        setupNavigationBar()
        //---
        configureTableView()
        //--
        v_timePicker = TimePicker(frame: CGRectMake(0, UIScreen.mainScreen().bounds.height, self.view.bounds.width, 300))
        
        //-----------
        reloadTableData()
        //-----------
        self.reloadData({ (Void) -> Void in
            self.reloadTableData()
        })
        //---------


    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        v_navigation.setTitle(" Đặt Lịch Làm Việc")
    }
}

//MARK: Data handler
extension ScheduleViewController {
    func reloadData(completion: (Void) -> Void) {
//        MMAppDataHelper.sharedInstance.syncClinicTimings { (success) -> Void in
//            completion()
//        }
    }
    
    func reloadTableData(){
//        self.ma_clinicTimings = MMRealmHelper.sharedInstance.db_getArrObjects(ClinicTiming.self)
        setTiming()
        self.tv_clinicTiming.reloadData()
    }
    
    func setTiming(){
//        ma_walkinTiming = []
//        for clinicTiming in self.ma_clinicTimings! {
//            for timing in clinicTiming.mct_timings {
//                self.ma_walkinTiming.append(timing)
//            }
//        }
    }
}

//MARK: Action handler
extension ScheduleViewController {
//    func addClinicTapped(sender: AnyObject?) {
//        self.view.endEditing(true)
//        let vc_createClinic = MMCreateClinicViewController(nibName: "MMCreateClinicViewController", bundle: nil)
//        self.navigationController?.pushViewController(vc_createClinic, animated: true)
//    }

    @IBAction func AddTimeClinicTapped(sender: UIButton) {
        if tapAction != .TimeSlot {
            tapAction = .TimeSlot
            sender.backgroundColor = MMColor.DeepBlue
        } else {
            tapAction = .Normal
            sender.backgroundColor = MMColor.SkyBlue
        }
        self.tv_clinicTiming.reloadData()
    }
    
    
//    func draggedView(sender: UIPanGestureRecognizer){
//        let location = sender.locationInView(view)
//        let translation = sender.translationInView(view)
//        let velocity = sender.velocityInView(view)
//        var viewToPan = self.v_addClinicTiming
//        
//        switch sender.state {
//        case .Began :
//            print("Began")
//            originalLocation = location
//            originalContentOrigin = viewToPan.frame.origin
//        case .Changed:
//            print("Changed")
//            let newOriginY = originalContentOrigin.y + location.y - originalLocation.y
//            let newOriginX = originalContentOrigin.x + location.x - originalLocation.x
//            viewToPan.frame.origin.y = newOriginY
//            viewToPan.frame.origin.x = newOriginX
//            print(viewToPan.frame.origin.y)
//        case .Ended:
//            print("ended")
//        case .Possible:
//            print("possible")
//        case .Cancelled:
//            print("cancelled")
//        case .Failed:
//            print("failed")
//        }
//    }
}

//MARK: UITableViewDelegate
extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    func configureTableView() {
        tv_clinicTiming.tableFooterView = UIView(frame: CGRectZero)
        tv_clinicTiming.registerNib(UINib(nibName: "ClinicTimingCell", bundle: nil), forCellReuseIdentifier: "ClinicTimingCell")
        tv_clinicTiming.registerNib(UINib(nibName: "MMAddClinicTimingCell", bundle: nil), forCellReuseIdentifier: "MMAddClinicTimingCell")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        let clinic = ma_clinicTimings![indexPath.row]
//        getArrayTimingTempForClinic(clinic)
//        let max = maxNumTimingForArrayTemp(ma_timingTemps!)
        var height = 35 * 2
        
        //-------------
        
//        switch tapAction{
//        case .TimeSlot:
//            if (clinic.mct_timings.count > 0){
//                height += (max * 35)
//            }
//            break
//        case .WalkingSlot:
//            if (clinic.mct_timings.count > 0){
//                height = (max * 35)
//            }
//            break
//        default:
//            if (clinic.mct_timings.count > 0){
//                height = (max * 35)
//            }
//            break
//        }
        
        return CGFloat(height)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //----------
//        let clinic = ma_clinicTimings![indexPath.row]
//        getArrayTimingTempForClinic(clinic)
        //----------
        let cell = tableView.dequeueReusableCellWithIdentifier("ClinicTimingCell", forIndexPath: indexPath) as! ClinicTimingCell
        
        cell.setButtonTime(cell.v_monday,status: tapAction)
        cell.setButtonTime(cell.v_tueday,status: tapAction)
        cell.setButtonTime(cell.v_wedday,status: tapAction)
        cell.setButtonTime(cell.v_thurday,status: tapAction)
        cell.setButtonTime(cell.v_friday,status: tapAction)
        cell.setButtonTime(cell.v_satday,status: tapAction)
        cell.setButtonTime(cell.v_sunday,status: tapAction)
        //------------------------
        cell.delegate = self
//        cell.lb_clinicName.text = clinic.mct_displayName == "" ? clinic.mct_name : clinic.mct_displayName
        
        return cell
    }
}

//MARK: ClinicTimingCellDelegate
extension ScheduleViewController: ClinicTimingCellDelegate {
    func didAddTiming(clinicId: Int){
        showAddClinicTimingView(clinicId)
    }
    
    func didTapTiming(clinicTiming: ClinicTiming, timing: MMTiming){
        showEditClinicTimingView(clinicTiming, timing: timing)
    }
    
    func getTimingTemp(day: String)-> MMTimingTemp{
        for timingTemp in self.ma_timingTemps!{
            if timingTemp.mtt_day == day{
                return timingTemp
            }
        }
        return MMTimingTemp()
    }
    
}

//MARK: Add Clinic Timing view
extension ScheduleViewController: AddClinicTimingViewDelegate {
    func showAddClinicTimingView(clinic: Int) {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let frame = CGRectMake(0, 0, screenSize.width * 0.9, screenSize.height/3*2)
        v_addClinicTiming = AddClinicTimingView(type: .AddTimeSlot, clinicId: clinic, frame: frame)
        v_addClinicTiming.delegate = self
        v_addClinicTiming.center = CGPointMake(screenSize.width/2, screenSize.height/2)
        v_addClinicTiming.view.applyShadow()
        
//        panRec.addTarget(self, action: "draggedView:")
//        self.v_addClinicTiming.addGestureRecognizer(panRec)
        
        // Animation show Add time slot
        
        animateOverlayShow()
        self.view.addSubview(v_addClinicTiming)
        //--------
        v_addClinicTiming.view.animation = Spring.AnimationPreset.FadeInDown.rawValue
        v_addClinicTiming.view.curve = Spring.AnimationCurve.EaseIn.rawValue
        v_addClinicTiming.view.duration = 0.5
        v_addClinicTiming.view.animate()
    }
    
    func showEditClinicTimingView(clinic: ClinicTiming, timing: MMTiming) {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let frame = CGRectMake(0, 0, screenSize.width * 0.9, screenSize.height/3*2)
        v_addClinicTiming = AddClinicTimingView(type: .EditTimeSlot ,timing: timing, clinicTiming: clinic, frame: frame)
        v_addClinicTiming.delegate = self
        v_addClinicTiming.center = CGPointMake(screenSize.width/2, screenSize.height/2)
        //---
        v_addClinicTiming.view.applyShadow()
        
        // Animation show Add time slot
        
        animateOverlayShow()
        self.view.addSubview(v_addClinicTiming)
        //-----
        //-----
        v_addClinicTiming.view.animation = Spring.AnimationPreset.FadeInDown.rawValue
        v_addClinicTiming.view.curve = Spring.AnimationCurve.EaseIn.rawValue
        v_addClinicTiming.view.duration = 0.5
        v_addClinicTiming.view.animate()
    }
    
    func hideAddClinicTimingView() {
//        reloadTableData()
        //-----------
        self.reloadData({ (Void) -> Void in
            self.reloadTableData()
        })
        //-------
        animateOverlayHide()
        v_addClinicTiming.view.animation = Spring.AnimationPreset.FadeOut.rawValue
        v_addClinicTiming.view.curve = Spring.AnimationCurve.EaseIn.rawValue
        v_addClinicTiming.view.duration = 0.5
        v_addClinicTiming.view.animateToNext { () -> () in
            self.v_addClinicTiming.removeFromSuperview()
        }
    }
    
    func addClinicTimingViewDidConfirm() {
        hideAddClinicTimingView()
        tapAction = .Normal
        btn_defTimeSlot.backgroundColor = MMColor.SkyBlue
        self.tv_clinicTiming.reloadData()
    }
    
    func addClinicTimingViewDidClose() {
//        MMAPI.getClinicTiming({ (listClinicTiming) -> Void in
//            MMRealmHelper.sharedInstance.db_syncObjects(listClinicTiming, deleteUnexisted: true)
//            var timings = [MMTiming]()
//            for clinicTiming in listClinicTiming {
//                timings.appendContentsOf(clinicTiming.mct_timings)
//            }
//            
//            MMRealmHelper.sharedInstance.db_syncObjects(timings, deleteUnexisted: true)
//            }) { (message) -> Void in
//                
//        }
        
        hideAddClinicTimingView()
    }
}

extension ScheduleViewController {
    func animateOverlayShow() {
        self.view.bringSubviewToFront(v_popupOverlay)
        UIView.animateWithDuration(0.5) { () -> Void in
            self.v_popupOverlay.alpha = 0.4
        }
    }
    
    func animateOverlayHide() {
        UIView.animateWithDuration(0.5) { () -> Void in
            self.v_popupOverlay.alpha = 0.0
        }
    }
}

//MARK: Time picker
extension ScheduleViewController {
    func showTimePicker() {
        if v_timePicker == nil {
            v_timePicker = TimePicker(frame: CGRectMake(0, UIScreen.mainScreen().bounds.height - 300, self.view.bounds.width, 300))
        }
    }
    
    func hideTimePicker(){
        UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.v_timePicker.frame = CGRectMake(0.0, UIScreen .mainScreen() .bounds.height, 1024, 300)
            }, completion: { finished in
                self.v_timePicker.hidden = true
        })
    }
}

//MARK: timing Temp

extension ScheduleViewController {
    func maxNumTimingForArrayTemp(arrTemp: Array<MMTimingTemp>) -> Int{
        var max = 0
        for timingTemp in arrTemp{
            max = timingTemp.mtt_timingList.count > max ? timingTemp.mtt_timingList.count : max
        }
        return max
    }
    
    func getArrayTimingTempForClinic (clinic: ClinicTiming) {
        ma_timingTemps = []
        var arrTiming = Array<MMTiming>()
        for timing in clinic.mct_timings{
            arrTiming.append(timing)
        }
        
    }
    
}
