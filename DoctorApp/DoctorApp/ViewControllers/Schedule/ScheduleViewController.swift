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
    var listTimmings: Array<Timings>?
    var timmingHospitalList: Array<Timings> = []
    var timmingHomeList: Array<Timings> = []

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
    var ma_timingTemps: Array<TimingTemp>?
    
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
        
        self.reloadData()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        v_navigation.setTitle(" Đặt Lịch Làm Việc")
    }
}

//MARK: Data handler
extension ScheduleViewController {
    func reloadData() {
        TimingsAPI.getTimings({ (arr) in
            print(arr)
            RealmHelper.sharedInstance.db_syncObjects(arr, deleteUnexisted:  true)
            self.reloadTableData()
        }) { (code, msg, params) in
        }
    }
    
//    func reloadData() {
//        TimingsAPI.getTimings({ (arr) in
//            print(arr)
//            self.timmingHospitalList = []
//            self.timmingHomeList = []
//            for tmpTimming: Timings in arr {
//                if tmpTimming.type == 0 {
//                    self.timmingHospitalList.append(tmpTimming)
//                } else{
//                    self.timmingHomeList.append(tmpTimming)
//                }
//            }
//            self.tv_clinicTiming.reloadData()
//        }) { (code, msg, params) in
//            Utils.showAlertWithError(msg)
//        }
//    }
    
    func reloadTableData(){
        listTimmings = RealmHelper.sharedInstance.db_getArrObjects(Timings.self)
        print(listTimmings)
        getTime()
        self.tv_clinicTiming.reloadData()
    }
    
    func getTime() {
        for tmpTimmings:Timings in listTimmings! {
            if tmpTimmings.type == 0 {
                self.timmingHospitalList.append(tmpTimmings)
            } else{
                self.timmingHomeList.append(tmpTimmings)
            }
        }
    }
}

//MARK: Action handler
extension ScheduleViewController {
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
        var height = 0
        if indexPath.row == 0 {
            height = 35 * (self.timmingHospitalList.count + 1)
        } else {
            height = 35 * (self.timmingHomeList.count + 1)
        }
        
        
        //-------------
        
        switch tapAction{
        case .TimeSlot:
//            if (timmingHospitalList.count > 0){
//                height += 35
//            }
            break
        case .WalkingSlot:
//            if (clinic.mct_timings.count > 0){
//                height += 35
//            }
            height = height + 35
            break
        default:
            break
        }
        
        return CGFloat(height)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ClinicTimingCell", forIndexPath: indexPath) as! ClinicTimingCell
        
        if indexPath.row == 0 {
            cell.setButtonTime(timmingHospitalList,currentView: cell.v_monday,status: tapAction, category: 0)
            cell.setButtonTime(timmingHospitalList,currentView: cell.v_tueday,status: tapAction, category: 0)
            cell.setButtonTime(timmingHospitalList,currentView: cell.v_wedday,status: tapAction, category: 0)
            cell.setButtonTime(timmingHospitalList,currentView: cell.v_thurday,status: tapAction, category: 0)
            cell.setButtonTime(timmingHospitalList,currentView: cell.v_friday,status: tapAction, category: 0)
            cell.setButtonTime(timmingHospitalList,currentView: cell.v_satday,status: tapAction, category: 0)
            cell.setButtonTime(timmingHospitalList,currentView: cell.v_sunday,status: tapAction, category: 0)
            //------------------------
            cell.delegate = self
            cell.clinicId = 0
            
            cell.lb_clinicName.text = "Tại phòng khám"
        } else if indexPath.row == 1 {
            cell.setButtonTime(timmingHomeList,currentView: cell.v_monday,status: tapAction, category: 1)
            cell.setButtonTime(timmingHomeList,currentView: cell.v_tueday,status: tapAction, category: 1)
            cell.setButtonTime(timmingHomeList,currentView: cell.v_wedday,status: tapAction, category: 1)
            cell.setButtonTime(timmingHomeList,currentView: cell.v_thurday,status: tapAction, category: 1)
            cell.setButtonTime(timmingHomeList,currentView: cell.v_friday,status: tapAction, category: 1)
            cell.setButtonTime(timmingHomeList,currentView: cell.v_satday,status: tapAction, category: 1)
            cell.setButtonTime(timmingHomeList,currentView: cell.v_sunday,status: tapAction, category: 1)
            //------------------------
            cell.delegate = self
            cell.clinicId = 1
            
            cell.lb_clinicName.text = "Tại nhà bệnh nhân"
        }
        
        return cell
    }
}

//MARK: ClinicTimingCellDelegate
extension ScheduleViewController: ClinicTimingCellDelegate {
    func didAddTiming(clinicId: Int){
        showAddClinicTimingView(clinicId)
    }
    
    func didTapTiming(clinicTiming: ClinicTiming, timing: Timings){
        showEditClinicTimingView(clinicTiming, timing: timing)
    }
    
    func getTimingTemp(day: String)-> TimingTemp{
        for timingTemp in self.ma_timingTemps!{
            if timingTemp.mtt_day == day{
                return timingTemp
            }
        }
        return TimingTemp()
    }
    
}

//MARK: Add Clinic Timing view
extension ScheduleViewController: AddClinicTimingViewDelegate {
    func showAddClinicTimingView(clinicId: Int) {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let frame = CGRectMake(0, 0, screenSize.width * 0.9, screenSize.height/3*2)
        v_addClinicTiming = AddClinicTimingView(type: .AddTimeSlot, clinicId: clinicId, frame: frame)
        v_addClinicTiming.delegate = self
        v_addClinicTiming.center = CGPointMake(screenSize.width/2, screenSize.height/2)
        v_addClinicTiming.view.applyShadow()
        
        // Animation show Add time slot
        
        animateOverlayShow()
        self.view.addSubview(v_addClinicTiming)
        //--------
        v_addClinicTiming.view.animation = Spring.AnimationPreset.FadeInDown.rawValue
        v_addClinicTiming.view.curve = Spring.AnimationCurve.EaseIn.rawValue
        v_addClinicTiming.view.duration = 0.5
        v_addClinicTiming.view.animate()
    }
    
    func showEditClinicTimingView(clinic: ClinicTiming, timing: Timings) {
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
        self.reloadData()
        
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
//            var timings = [Timing]()
//            for clinicTiming in listClinicTiming {
//                timings.appendContentsOf(clinicTiming.mct_timings)
//            }
//            
//            MMRealmHelper.sharedInstance.db_syncObjects(timings, deleteUnexisted: true)
//            }) { (message) -> Void in
//                
//        }
        
//        self.reloadData()
        
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

//extension ScheduleViewController {
//    func maxNumTimingForArrayTemp(arrTemp: Array<TimingTemp>) -> Int{
//        var max = 0
//        for timingTemp in arrTemp{
//            max = timingTemp.mtt_timingList.count > max ? timingTemp.mtt_timingList.count : max
//        }
//        return max
//    }
//    
//    func getArrayTimingTempForClinic (clinic: ClinicTiming) {
//        ma_timingTemps = []
//        var arrTiming = Array<Timing>()
//        for timing in clinic.mct_timings{
//            arrTiming.append(timing)
//        }
//        
//    }
//    
//}
