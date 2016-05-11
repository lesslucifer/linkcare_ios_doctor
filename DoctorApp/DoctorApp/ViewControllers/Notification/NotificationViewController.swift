//
//  NotificationViewController.swift
//  DoctorApp
//
//  Created by Edward Nguyen on 5/2/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import Foundation

class NotificationViewController: BaseMenuViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        
        v_navigation.addBackButton()
        v_navigation.setTitle("THÔNG BÁO")
    }
}