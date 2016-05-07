//
//  AppointmentCell.swift
//  DoctorApp
//
//  Created by Edward Nguyen on 4/30/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit

class AppointmentCell: UITableViewCell {
    @IBOutlet var lb_time: UILabel!
    @IBOutlet var lb_noPatient: UILabel!
    @IBOutlet var lb_noSlots: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
