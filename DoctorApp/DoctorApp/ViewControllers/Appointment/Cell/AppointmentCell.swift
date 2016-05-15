//
//  AppointmentCell.swift
//  DoctorApp
//
//  Created by Edward Nguyen on 4/30/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit

protocol AppointmentCellProtocol {
    func configure(appointment: Appointment?)
    func waiting(enabled: Bool)
}

class AppointmentCell: UITableViewCell, AppointmentCellProtocol {
    @IBOutlet var lb_time: UILabel!
    @IBOutlet weak var lb_name: UILabel!
    @IBOutlet weak var lb_gender: UILabel!
    @IBOutlet weak var lb_age: UILabel!
    @IBOutlet weak var vWaiting: UIView!
    @IBOutlet weak var aiLoading: UIActivityIndicatorView!
    
    var appointment: Appointment?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(appointment: Appointment?) {
        self.appointment = appointment
        
        if let app = appointment {
            lb_time.text = "\(DateFormat.formatMinuteTime(app.time))\n\(DateFormat.dateDotFormatter.stringFromDate(app.date))"
            lb_name.text = app.patient!.name
            lb_gender.text = app.patient!.gender.str()
            lb_age.text = "\(Utils.age(app.patient!.birth))"
        }
        else {
            lb_time.text = ""
            lb_name.text = ""
            lb_gender.text = ""
            lb_age.text = ""
        }
    }
    
    func waiting(enabled: Bool) {
        self.userInteractionEnabled = !enabled
        vWaiting.hidden = !enabled
        if enabled {
            aiLoading.startAnimating()
        }
        else {
            aiLoading.stopAnimating()
        }
    }
}
