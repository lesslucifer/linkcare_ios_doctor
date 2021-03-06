//
//  BaseMenuViewController.swift
//  DoctorApp
//
//  Created by Edward Nguyen on 4/30/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit

protocol DataPickerDelegate {
    func DataPickerDidSelectData(picker: DataPicker, data: String, didSelectRow row: Int)
    func DataPickerDidDismiss()
}

class DataPicker: UIView {
    @IBOutlet var view: UIView!
    @IBOutlet var v_picker: UIPickerView!
    var a_data: Array<String>!
    var delegate: DataPickerDelegate?
    var tf_current: UITextField?
    var isDidselectRow: Bool = false
    //---
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        //---
        NSBundle.mainBundle().loadNibNamed("DataPicker", owner: self, options: nil)
        //---
        self.view.frame = CGRectMake(0, 0, self.frame.width, self.frame.height)
        //---
        self.addSubview(self.view)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //---
        NSBundle.mainBundle().loadNibNamed("DataPicker", owner: self, options: nil)
        //---
        self.view.frame = CGRectMake(0, 0, frame.width, frame.height)
        //---
        self.addSubview(self.view)
    }
    
    func setData(data: Array<String>) {
        a_data = data
        v_picker.reloadAllComponents()
    }
}

extension DataPicker {
    @IBAction func doneClicked(sender: AnyObject) {
        if(!isDidselectRow && a_data != nil && a_data.count != 0){
            tf_current?.text = a_data[v_picker.selectedRowInComponent(0)]
            delegate?.DataPickerDidSelectData(self, data: a_data[v_picker.selectedRowInComponent(0)], didSelectRow: v_picker.selectedRowInComponent(0))
        }
        delegate?.DataPickerDidDismiss()
        tf_current?.resignFirstResponder()
    }
}

extension DataPicker: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return a_data != nil ? a_data.count : 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return a_data != nil ? a_data[row] : ""
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if(a_data != nil && a_data.count != 0){
            tf_current?.text = a_data[row]
            delegate?.DataPickerDidSelectData(self, data: a_data[row], didSelectRow: row)
            isDidselectRow = true
        }
    }
}
