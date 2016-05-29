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
    var listNotificationRead: [Int] = []
    
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
            self.tbNotification.reloadData()
            
        }) { (code, msg, params) in
            Utils.showOKAlertPanel(self, title: "Rất tiếc", msg: "Không tải được thông tin, xin vui lòng thử lại!")
            self.notifications = []
            self.tbNotification.reloadData()
        }
    }
    
    func sendNotificationRead(listNotificationRead: [Int]){
        NotificationAPI.setNotificationRead(listNotificationRead) { (success, code, msg, params) in
//            print(success)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        
//        v_navigation.addBackButton()
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
        
        
        if let notification = NotificationCache.INST.get(idNotification) {
            cell.configure(notification)
        } else {
            NotificationCache.INST.get(idNotification, fetcher: { notification in
                if notification != nil {
                    tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                }
            })
        }
        
        //add id to  readlist
        if !listNotificationRead.contains(idNotification){
            listNotificationRead.append(idNotification)
            self.sendNotificationRead(listNotificationRead)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let bufferedCaches = (0..<10).map({indexPath.row + $0}).filter({$0 < notifications.count}).map({notifications[$0]})
        
        if !bufferedCaches.isEmpty {
            NotificationCache.INST.fetch(bufferedCaches, fetcher: nil)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
    }
}