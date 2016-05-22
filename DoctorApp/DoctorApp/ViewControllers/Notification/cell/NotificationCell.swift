//
//  NotificationCell.swift
//  DoctorApp
//
//  Created by Edward Nguyen on 4/30/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    @IBOutlet var lbNotification: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(notification: Notification) {
        self.lbNotification.text = notification.content
    }
}
