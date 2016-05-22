//
//  NotificationViewController.swift
//  DoctorApp
//
//  Created by Edward Nguyen on 5/2/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import Foundation
import UIKit

class NotificationViewController: BaseMenuViewController {
    @IBOutlet var tbNotification: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        self.configureTableView()
        

        NotificationAPI.getNotifications({ (arr) in
            print(arr)
            
            }) { (code, msg, params) in
                print(msg)
        }
        
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

extension NotificationViewController: UITableViewDataSource, UITableViewDelegate {
    func configureTableView() {
        tbNotification.registerNib(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: "NotificationCell")
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NotificationCell", forIndexPath: indexPath) as! NotificationCell
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
    }
}