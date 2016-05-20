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
//        tf_timefrom.hidden = true
//        tf_timeto.hidden = true
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

