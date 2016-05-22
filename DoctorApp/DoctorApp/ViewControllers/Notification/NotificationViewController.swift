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
    var notifications: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        self.configureTableView()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getNotificationIds()
    }
    
    func getNotificationIds() {
        NotificationAPI.getNotifications({ (arr) in
            self.notifications = arr
            self.getnotificationDetail(arr)
            
            self.tbNotification.reloadData()
            
        }) { (code, msg, params) in
            Utils.showOKAlertPanel(self, title: "Rất tiếc", msg: "Không tải được thông tin, xin vui lòng thử lại!")
            self.notifications = []
            self.tbNotification.reloadData()
        }
    }
    
    func getnotificationDetail(listNotification: [Int]) {
        NotificationAPI.getNotifications(listNotification, success: { (arr) in
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
        return notifications.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NotificationCell", forIndexPath: indexPath) as! NotificationCell
        
        let idNotification = notifications[indexPath.row]
        
//        let notification = NotificationCache.shareInstance.get(idNotification) {
//
//            cell.configure(notification)
//            
//        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
    }
}