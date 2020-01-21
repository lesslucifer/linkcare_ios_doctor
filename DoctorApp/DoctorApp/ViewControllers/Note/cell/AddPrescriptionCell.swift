//
//  AddPrescriptionCell.swift
//  DoctorApp
//
//  Created by Edward Nguyen on 4/30/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit

class AddPrescriptionCell: UITableViewCell {
    @IBOutlet var btnAdd: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnAdd.linkcarelize()
    }
    
//    func configure() {
//    }
}
