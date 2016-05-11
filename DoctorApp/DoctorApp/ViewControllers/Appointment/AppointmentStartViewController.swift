//
//  AppointmentStartViewController.swift
//  DoctorApp
//
//  Created by Edward Nguyen on 5/10/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit

class AppointmentStartViewController: UIViewController {

    @IBOutlet var tbAppointment: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension AppointmentStartViewController: UITableViewDataSource, UITableViewDelegate {
    func configureTableView() {
        tbAppointment.registerNib(UINib(nibName: "AppointmentCell", bundle: nil), forCellReuseIdentifier: "AppointmentCell")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AppointmentCell", forIndexPath: indexPath) as! AppointmentCell
        return cell
        
    }
}


