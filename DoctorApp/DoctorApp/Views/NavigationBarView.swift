//
//  NavigationBarView.swift
//  DoctorApp
//
//  Created by Edward Nguyen on 4/30/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit

class NavigationBarView: UIView {
    @IBOutlet var view: UIView!
    @IBOutlet var btn_back: UIButton!
    @IBOutlet var lb_title: UILabel!
    @IBOutlet var btn_menu: UIButton!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        NSBundle.mainBundle().loadNibNamed("NavigationBarView", owner: self, options: nil)
        self.view.frame = CGRectMake(0, 0, self.frame.width, self.frame.height)
        self.addSubview(self.view)
        
        btn_back.hidden = true
        
        self.view.applyShadow()
    }
    
    func setTitle(title: String) {
        lb_title.text = title
    }
    
    func addBackButton() {
        btn_back.hidden = false
    }
}
