//
//  PrescriptionCell.swift
//  DoctorApp
//
//  Created by Edward Nguyen on 4/30/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit

class PrescriptionCell: UITableViewCell {
    @IBOutlet var tfQuantityTotal: UITextField!
    @IBOutlet var tfquantityMorning: UITextField!
    @IBOutlet var tfquantityNoon: UITextField!
    @IBOutlet var tfquantityAfterNoon: UITextField!
    @IBOutlet var tfquantityNight: UITextField!
    @IBOutlet var tfInstr: UITextField!
    @IBOutlet var tfName: UITextField!
    
    @IBOutlet var btnDelete: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setLayout()
    }
    
    func setLayout() {
        let numberToolbar = UIToolbar(frame: CGRectMake(0, 0, self.frame.size.width, 50))
        numberToolbar.barStyle = UIBarStyle.Default
        
        numberToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Xong", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(PrescriptionCell.dismissKeyboard))]
        
        numberToolbar.sizeToFit()
        
        tfQuantityTotal.inputAccessoryView = numberToolbar
    }
    
    func dismissKeyboard() {
        tfQuantityTotal.endEditing(true)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField == tfQuantityTotal {
            let newCharacters = NSCharacterSet(charactersInString: string)
            return NSCharacterSet.decimalDigitCharacterSet().isSupersetOfSet(newCharacters)
        }
        
        return true
    }
    
    
}
