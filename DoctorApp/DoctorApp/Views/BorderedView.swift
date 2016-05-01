//
//  BorderedView.swift
//  DoctorApp
//
//  Created by Edward Nguyen on 4/30/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit

class BorderedView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.borderWidth = 1.0
        self.layer.borderColor = Utils.UIColorFromRGB(red: 224, green: 224, blue: 224).CGColor
    }
}

