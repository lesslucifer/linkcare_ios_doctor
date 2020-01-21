//
//  NotificationCell.swift
//  DoctorApp
//
//  Created by Edward Nguyen on 4/30/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    @IBOutlet var lbNotif: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(notification: Notification?, isUnread: Bool) {
        self.lbNotif.text = ""
        
        if let notif = notification {
            var attrStr: NSAttributedString?
            do {
                let content = "<style>body{font-family: '\("Myriad Pro")'; font-size:\(17)px; color: #\(LCColor.LightCyanHex)}</style> \(notif.content)"
                
                try attrStr = NSMutableAttributedString(
                    data: content.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
                    options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                    documentAttributes: nil)
            }
            catch ( _) {
                attrStr = nil
            }
            
            if attrStr != nil {
                self.lbNotif.attributedText = attrStr
            }
            else {
                self.lbNotif.text = notif.content
            }
        }
        else {
            lbNotif.text = "<Đang tải>"
        }
        
        self.contentView.backgroundColor = (isUnread) ? LCColor.WeakCyan : UIColor.whiteColor()
    }
}
