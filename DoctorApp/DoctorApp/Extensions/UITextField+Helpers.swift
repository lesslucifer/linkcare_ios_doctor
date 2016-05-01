//
//  UITextField+Helpers.swift
//  DoctorApp
//
//  Created by Edward Nguyen on 5/1/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import Foundation
import Reachability

extension UITextField {
    func underlineTextField() {
        let border = CALayer()
        let width = CGFloat(0.5)
        border.borderColor = Utils.UIColorFromRGB(red: 162, green: 201, blue: 218).CGColor
        border.frame = CGRect(x: 0, y: frame.size.height - width, width:  frame.size.width, height: frame.size.height)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

