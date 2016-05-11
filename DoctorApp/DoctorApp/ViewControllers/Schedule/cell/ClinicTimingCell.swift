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
    func didTapTiming(clinicTiming: ClinicTiming, timing: MMTiming)
}

class ClinicTimingCell: UITableViewCell {
    @IBOutlet weak var lb_clinicName: UILabel!
    var ma_Timing = Array<MMTiming>()
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
    var timingSelected = MMTiming()
    //----
    let arrDay = ["mon", "tue", "wed", "thu", "fri", "sat", "sun"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layoutMargins = UIEdgeInsetsZero;
        self.preservesSuperviewLayoutMargins = false;
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}

//MARK: Layout handle
extension ClinicTimingCell {
    func setButtonTime(currentView: UIView, status: DefineClinic) {
        currentView.removeAllSubviews()
        
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
        
        if (status == DefineClinic.TimeSlot){
            let frame = CGRect(x: 0, y: CGFloat(1 * 35), width: currentView.frame.size.width, height: 35)
            
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
        for timing in clinicTimingSelected.mct_timings{
            if (timing.mt_Id == "\(sender.tag)"){
                timingSelected = timing
            }
        }
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