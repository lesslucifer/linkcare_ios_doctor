//
//  MenuView.swift
//  DoctorApp
//
//  Created by Edward Nguyen on 4/30/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import Foundation

import UIKit
import Spring

protocol RightMenuDelegate {
    func hideMenuClicked()
    func menu_didSelect(menu: RightMenu)
}

class MenuView: UIView {
    @IBOutlet var view: SpringView!
    @IBOutlet var tbl_menu: UITableView!
    
    var delegate: RightMenuDelegate!
    
    var listMenuTitle: NSMutableArray = ["TRANG CHỦ", "THÔNG TIN CÁ NHÂN", "LỊCH HẸN", "LỊCH LÀM VIỆC", "THÔNG BÁO", "ĐĂNG XUẤT"]
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        NSBundle.mainBundle().loadNibNamed("MenuView", owner: self, options: nil)
        
        self.view.frame = CGRectMake(0, 0, self.frame.width, self.frame.height)
        
        self.addSubview(self.view)
        
        configureTableView()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        NSBundle.mainBundle().loadNibNamed("MenuView", owner: self, options: nil)
        
        self.view.frame = CGRectMake(0, 0, frame.width, frame.height)
        
        self.addSubview(self.view)
        
        configureTableView()
        
    }
    
    //MARK: Action Handle
    @IBAction func hideMenuClicked(sender: UIButton) {
        self.delegate?.hideMenuClicked()
    }
}

extension MenuView: UITableViewDelegate, UITableViewDataSource {
    func configureTableView() {
        tbl_menu.tableFooterView = UIView(frame: CGRectZero)
        tbl_menu.registerNib(UINib(nibName: "MenuCell", bundle: nil), forCellReuseIdentifier: "MenuCell")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listMenuTitle.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell" , forIndexPath: indexPath) as! MenuCell
                
        cell.lb_cellTitle.text = listMenuTitle[indexPath.row] as? String
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.menuRowDidTapped(indexPath.row)
        
        tbl_menu.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    func menuRowDidTapped(index: Int) {
        switch (index)
        {
        case 0:
            self.delegate.menu_didSelect(.Home)
            break
        case 1:
            self.delegate.menu_didSelect(.Profile)
            break
        case 2:
            self.delegate.menu_didSelect(.Appointments)
            break
        case 3:
            self.delegate.menu_didSelect(.Schedule)
            break
        case 4:
            self.delegate.menu_didSelect(.Notification)
            break
        case 5:
            self.delegate.menu_didSelect(.SignOut)
            break
        default:
            break
        }
    }
}