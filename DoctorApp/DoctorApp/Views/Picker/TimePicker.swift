//
//  BaseMenuViewController.swift
//  DoctorApp
//
//  Created by Edward Nguyen on 4/30/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit

protocol TimePickerDelegate {
    func pickerDidSelectTime(time: String) //Format: hh:mm
}

class TimePicker: UIView {
    @IBOutlet var view: UIView!
    @IBOutlet var datePicker: UIDatePicker!
    //---
    var currentTextField: UITextField?
    var delegate: TimePickerDelegate?
    //---
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        //---
        NSBundle.mainBundle().loadNibNamed("TimePicker", owner: self, options: nil)
        //---
        self.view.frame = CGRectMake(0, 0, self.frame.width, self.frame.height)
        //---
        self.addSubview(self.view)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //---
        NSBundle.mainBundle().loadNibNamed("TimePicker", owner: self, options: nil)
        //---
        self.view.frame = CGRectMake(0, 0, frame.width, frame.height)
        //---
        self.addSubview(self.view)
    }
}

extension TimePicker {
    @IBAction func dataPickerChanged(datePicker: UIDatePicker) {
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateStyle = .ShortStyle
        timeFormatter.dateFormat = "HH:mm"
        timeFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        //---
        let time = timeFormatter.stringFromDate(datePicker.date)
        currentTextField?.text = time
        delegate?.pickerDidSelectTime(time)
    }
    
    @IBAction func doneClicked(sender: AnyObject) {
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateStyle = .ShortStyle
        timeFormatter.dateFormat = "HH:mm"
        timeFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        //---
        currentTextField?.text = timeFormatter.stringFromDate(datePicker.date)
        currentTextField?.resignFirstResponder()
        delegate?.pickerDidSelectTime((currentTextField?.text)!)
    }
}
