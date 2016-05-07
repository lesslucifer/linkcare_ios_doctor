//
//  UIView+Helpers.swift
//  DoctorApp
//
//  Created by Edward Nguyen on 4/30/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import Foundation
import Reachability

extension UIView {
    func applyShadow() {
        let layer = self.layer
        
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 5
    }
    
    public func removeAllSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
}