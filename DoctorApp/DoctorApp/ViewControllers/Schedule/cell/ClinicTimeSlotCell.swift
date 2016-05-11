//
//  BaseMenuViewController.swift
//  DoctorApp
//
//  Created by Edward Nguyen on 4/30/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit

class ClinicTimeSlotCell: UITableViewCell {
    @IBOutlet weak var tf_timefrom: UITextField!
    @IBOutlet weak var tf_timeto: UITextField!
    @IBOutlet weak var tf_timeSlot: UITextField!
    @IBOutlet weak var tf_patientSlot: UITextField!
    
    @IBOutlet var iv_delete: UIImageView!
//    @IBOutlet var iv_addNewSlot: UIImageView!
    @IBOutlet var lb_numberSlot:UILabel!
    
    @IBOutlet var btn_addNewBlock:UIButton!
    @IBOutlet var btn_deleteBlock:UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layoutMargins = UIEdgeInsetsZero;
        self.preservesSuperviewLayoutMargins = false;
        
        //---
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
}

//MARK: Layout handle
extension ClinicTimeSlotCell {
    func configureAsAddNewCell() {
        lb_numberSlot.hidden = true
//        iv_addNewSlot.hidden = false
        tf_timefrom.hidden = true
        tf_timeto.hidden = true
        tf_timeSlot.hidden = true
        tf_patientSlot.hidden = true
        iv_delete.hidden = true
        btn_addNewBlock.userInteractionEnabled = true
        btn_addNewBlock.hidden = false
        btn_deleteBlock.userInteractionEnabled = false
        btn_deleteBlock.hidden = true
    }
    
    func configureDefaultCell() {
        lb_numberSlot.hidden = false
//        iv_addNewSlot.hidden = true
        tf_timefrom.hidden = false
        tf_timeto.hidden = false
        tf_timeSlot.hidden = false
        tf_patientSlot.hidden = false
        iv_delete.hidden = false
        btn_addNewBlock.userInteractionEnabled = false
        btn_addNewBlock.hidden = true
        btn_deleteBlock.userInteractionEnabled = true
        btn_deleteBlock.hidden = false
    }
}

//extension ClinicTimeSlotCell {
//    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
//        if textField == tf_timefromhours ||
//            textField == tf_timefromminute ||
//            textField == tf_timetohours ||
//            textField == tf_timetominute {
////                v_timePicker.currentTextField = textField
////                textField.inputView = v_timePicker
//                print("33")
//                return true
//        }
//        
//        return true
//    }
//}

