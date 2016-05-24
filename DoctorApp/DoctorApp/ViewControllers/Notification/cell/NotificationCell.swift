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
        var attrStr = try! NSAttributedString(
            data: notification.content.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil)
        
//        self.lbNotification.text = notification.content
        self.lbNotification.attributedText = attrStr
    }
}
