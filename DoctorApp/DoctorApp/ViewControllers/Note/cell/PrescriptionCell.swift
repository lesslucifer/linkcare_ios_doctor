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
    }
    
//    func configure() {
//    }
}
