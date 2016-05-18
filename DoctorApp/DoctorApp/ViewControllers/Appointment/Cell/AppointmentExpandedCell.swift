//
//  AppointmentExpandedCell.swift
//  DoctorApp
//
//  Created by Salm on 5/13/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit

class AppointmentExpandedCell: UITableViewCell, AppointmentCellProtocol {

    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbPosition: UILabel!
    @IBOutlet weak var lbPhone: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var lbSymtoms: UILabel!
    @IBOutlet weak var lbGender: UILabel!
    @IBOutlet weak var lbAge: UILabel!
    
    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var vWaiting: UIView!
    @IBOutlet weak var aiLoading: UIActivityIndicatorView!
    
    var okHandler, cancelHandler: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(appointment: Appointment?) {
        if let app = appointment {
            lbTime.text = "\(DateFormat.formatMinuteTime(app.time))\n\(DateFormat.dateDotFormatter.stringFromDate(app.date))"
            lbName.text = app.patient?.name
            lbPosition.text = app.type.str()
            lbPhone.text = app.patient?.phone
            lbAddress.text = app.patient?.address
            lbSymtoms.text = app.patient?.symtoms
            lbGender.text = app.patient?.gender.str()
            lbAge.text = String(Utils.age(app.patient!.birth))
            
            btnOK.hidden = false
            btnCancel.hidden = false
        }
        else {
            lbTime.text = ""
            lbName.text = ""
            lbPosition.text = ""
            lbPhone.text = ""
            lbAddress.text = ""
            lbSymtoms.text = ""
            lbGender.text = ""
            lbAge.text = ""
            
            btnOK.hidden = true
            btnCancel.hidden = true
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
    
    func configureToStartButton() {
        
    }
    
    @IBAction func btnOkPressed(sender: AnyObject) {
        self.okHandler?()
    }
    
    @IBAction func btnCancelPressed(sender: AnyObject) {
        self.cancelHandler?()
    }
}
