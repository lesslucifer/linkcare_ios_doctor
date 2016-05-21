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
    func didTapTiming(timing: Timings, clinicId: Int)
}

class ClinicTimingCell: UITableViewCell {
    @IBOutlet weak var lb_clinicName: UILabel!
    var delegate: ClinicTimingCellDelegate!
    var listTimmingSelected = [Timings]()
    var timingSelected = Timings()
    
    var clinicId = 0
    
    @IBOutlet var v_monday: UIView!
    @IBOutlet var v_tueday: UIView!
    @IBOutlet var v_wedday: UIView!
    @IBOutlet var v_thurday: UIView!
    @IBOutlet var v_friday: UIView!
    @IBOutlet var v_satday: UIView!
    @IBOutlet var v_sunday: UIView!
    
    //----
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
    func setButtonTime(timingTemp: [Timings], currentView: UIView, status: DefineClinic, category: Int) {
        currentView.removeAllSubviews()
        
        for (var i = 0; i < timingTemp.count; i++){
            let timing = timingTemp[i]
            let frame = CGRect(x: 0, y: CGFloat(i * 35), width: currentView.frame.size.width, height: 34)
            let button = UIButton(frame: frame)
            //-------------
            button.setTitle("\(Utils.converTimetoString(timing.beginTime)) - \(Utils.converTimetoString(timing.endTime))", forState: UIControlState.Normal)
            button.titleLabel!.font = UIFont(name: "HelveticaNeue", size: 10)
            button.backgroundColor = Utils.UIColorFromRGB(red: 243, green: 101, blue: 35)
            
            button.tag = timing.id
            
            if(status == DefineClinic.TimeSlot){
                button.addTarget(self, action: #selector(ClinicTimingCell.showTimingClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            }else{
                button.removeTarget(self, action: nil, forControlEvents: UIControlEvents.AllEvents)
            }
            
            listTimmingSelected = timingTemp
            
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
        delegate.didAddTiming(self.clinicId)
    }
    
    @IBAction func showTimingClicked(sender: UIButton){        
        for timing in listTimmingSelected {
            if (timing.id == sender.tag) {
                timingSelected = timing
            }
        }
        delegate.didTapTiming(timingSelected, clinicId: self.clinicId)
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