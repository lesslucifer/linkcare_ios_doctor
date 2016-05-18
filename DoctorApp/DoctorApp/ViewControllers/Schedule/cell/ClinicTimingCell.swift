//
//  BaseMenuViewController.swift
//  DoctorApp
//
//  Created by Edward Nguyen on 4/30/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit

protocol ClinicTimingCellDelegate {
    func didAddTiming(clinicId: Int)
    func didTapTiming(clinicTiming: ClinicTiming, timing: Timing)
}

class ClinicTimingCell: UITableViewCell {
    @IBOutlet weak var lb_clinicName: UILabel!
    var ma_Timing = Array<Timing>()
    //---
    var delegate: ClinicTimingCellDelegate!
    //---

    @IBOutlet var v_monday: UIView!
    @IBOutlet var v_tueday: UIView!
    @IBOutlet var v_wedday: UIView!
    @IBOutlet var v_thurday: UIView!
    @IBOutlet var v_friday: UIView!
    @IBOutlet var v_satday: UIView!
    @IBOutlet var v_sunday: UIView!
    
    var clinicTimingSelected = ClinicTiming()
    var timingSelected = Timing()
    //----
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layoutMargins = UIEdgeInsetsZero;
        self.preservesSuperviewLayoutMargins = false;
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func converTimetoHour(time: Int) -> Int {
        return (time - time%60) / 60
    }
    
    func converTimetoMinute(time: Int) -> Int {
        return time%60
    }
    
    func conerTimetoString(time: Int) -> String {
        return "\(converTimetoHour(time)) : \(converTimetoMinute(time))"
    }
}

//MARK: Layout handle
extension ClinicTimingCell {
    func setButtonTime(timingTemp: [Timings], currentView: UIView, status: DefineClinic, category: Int) {
        currentView.removeAllSubviews()
        
        for (var i = 0; i < timingTemp.count; i++){
            let timing = timingTemp[i]
            let frame = CGRect(x: 0, y: CGFloat(i * 35), width: currentView.frame.size.width, height: 34)
            let button = UIButton(frame: frame)
            //-------------
            button.setTitle("\(conerTimetoString(timing.beginTime)) - \(conerTimetoString(timing.endTime))", forState: UIControlState.Normal)
            button.titleLabel!.font = UIFont(name: "HelveticaNeue", size: 10)
            button.backgroundColor = Utils.UIColorFromRGB(red: 243, green: 101, blue: 35)
            
            if category == 0 {
               button.tag = i
            } else {
                button.tag = i * 1000
            }
            
            
            if(status == DefineClinic.TimeSlot){
                button.addTarget(self, action: #selector(ClinicTimingCell.showTimingClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            }else{
                button.removeTarget(self, action: nil, forControlEvents: UIControlEvents.AllEvents)
            }
            
            currentView.addSubview(button)
        }
        
        /*
        let frame = CGRect(x: 0, y: CGFloat(0 * 35), width: currentView.frame.size.width, height: 34)
        let button = UIButton(frame: frame)
        //-------------
        button.setTitle("9:00 - 10:00", forState: UIControlState.Normal)
        button.backgroundColor = Utils.UIColorFromRGB(red: 243, green: 101, blue: 35)
        
        if(status == DefineClinic.TimeSlot){
            button.addTarget(self, action: #selector(ClinicTimingCell.showTimingClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        }else{
            button.removeTarget(self, action: nil, forControlEvents: UIControlEvents.AllEvents)
        }
        
        currentView.addSubview(button)
        */
        
        if (status == DefineClinic.TimeSlot){
            let frame = CGRect(x: 0, y: CGFloat(timingTemp.count * 35), width: currentView.frame.size.width, height: 35)
            
            let button = UIButton(frame: frame)
            button.setTitle("+", forState: UIControlState.Normal)
            button.backgroundColor = UIColor.whiteColor()
            button.setTitleColor(Utils.UIColorFromRGB(red: 0, green: 173, blue: 239), forState: UIControlState.Normal)
            
            button.addTarget(self, action: #selector(ClinicTimingCell.addTimingClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            currentView.addSubview(button)
        }
        
    }
}

//MARK: Action handler
extension ClinicTimingCell {
    @IBAction func addTimingClicked(sender: UIButton) {
        let clinicId = sender.tag / 1000
        let dayIndex = sender.tag % 1000
        delegate.didAddTiming(clinicId)
    }
    
    @IBAction func showTimingClicked(sender: UIButton){
//        for timing in clinicTimingSelected.mct_timings{
//            if (timing.mt_Id == "\(sender.tag)"){
//                timingSelected = timing
//            }
//        }
        delegate.didTapTiming(clinicTimingSelected, timing: timingSelected)
    }
}

//extension Array{
//    func indexOfValue(value: String) -> Int{
//        for (var i = 0 ; i < self.count ; i++){
//            if self[i] as! String == value{
//                return i
//            }
//        }
//        return 0
//    }
//}