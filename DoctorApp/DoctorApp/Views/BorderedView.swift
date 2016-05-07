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
        
        self.layer.borderWidth = 2.0
        self.layer.borderColor = Utils.UIColorFromRGB(red: 84, green: 160, blue: 191).CGColor
    }
}

