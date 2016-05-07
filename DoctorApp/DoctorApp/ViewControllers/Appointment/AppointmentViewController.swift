//
//  AppointmentViewController.swift
//  DoctorApp
//
//  Created by Edward Nguyen on 4/29/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import Foundation
import UIKit

class AppointmentViewController: BaseMenuViewController {
    @IBOutlet var tbAppointment: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        configureTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        
        v_navigation.addBackButton()
        v_navigation.setTitle("LỊCH HẸN")
    }
    
    func notedClicked() {
        let storyboard = UIStoryboard(name: "NoteStoryboard", bundle: nil)
        let vc_destination = storyboard.instantiateViewControllerWithIdentifier("dashboard") as! NoteViewController
        self.navigationController?.pushViewController(vc_destination, animated: true)
    }
}

extension AppointmentViewController: UITableViewDataSource, UITableViewDelegate {
    func configureTableView() {
        tbAppointment.registerNib(UINib(nibName: "AppointmentCell", bundle: nil), forCellReuseIdentifier: "AppointmentCell")
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AppointmentCell", forIndexPath: indexPath) as! AppointmentCell
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        self.notedClicked()
    }
}