//
//  HomeViewController.swift
//  DoctorApp
//
//  Created by Edward Nguyen on 4/30/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit

class HomeViewController: BaseMenuViewController {
    @IBOutlet var lb_welcome: UILabel!
    @IBOutlet var sv_container: UIScrollView!
    @IBOutlet var tbHospital: UITableView!
    @IBOutlet var tbHome: UITableView!
    @IBOutlet var vtop: UIView!
    @IBOutlet var v_ailmentContainer: BorderedView!
    @IBOutlet var img_doctor: UIImageView!
    @IBOutlet weak var lb_time: UILabel!

    var profile = UserProfile()
    var listMedicar:[CacheModel] = []
    var listHospitalTimmingSlot:[TimmingSlot] = []
    var listHomeTimmingSlot:[TimmingSlot] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        setupNavigationBar()
        updateTime()
        configureTableView()
        
        loadData()
        
        loadMedicarAppointment()
        loadMedicarTimmingSlot()
    }

    func loadData() {
        ProfileAPI.getUserProfile({ (obj) in
            print(obj)
            self.profile = obj!
            
            self.setupLayout()
        }) { (code, msg, params) in
            
        }
    }
    
    func loadMedicarAppointment(){
        let date = NSDate()
        
        AppointmentAPI.getMedicarAppointments(date, success: { (arr) in
            self.listMedicar = arr
            self.tbHome.reloadData()
            self.tbHospital.reloadData()
            }, failure: { code, msg, pars in
                self.listMedicar = []
                self.tbHome.reloadData()
                self.tbHospital.reloadData()
        })
    }
    
    func loadMedicarTimmingSlot() {
        let date = NSDate()
        
        TimingSlotAPI.getMedicarTimingSlot(date, success: { (arr) in
            self.listHospitalTimmingSlot = arr.filter({ $0.type == 0})
            self.listHomeTimmingSlot = arr.filter({ $0.type == 1})
            self.tbHome.reloadData()
            self.tbHospital.reloadData()
        }, failure: { code, msg, pars in
            self.listHospitalTimmingSlot = []
            self.tbHome.reloadData()
            self.tbHospital.reloadData()
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}
//MARK: Set Layout
extension HomeViewController{
    func setupLayout(){
        self.lb_welcome.text = "Xin chào, Bác sĩ \(profile.fullName)!"
    }
}

//MARK: Action handler
extension HomeViewController {
    override func setupNavigationBar() {
        super.setupNavigationBar()
        v_navigation.setTitle("TRANG CHỦ")
    }
    
    func updateTime() {
        let time = NSDate()
        let formatter = DateFormat.dateTimeFullFormatter
        
        let text = "\(formatter.stringFromDate(time))"
        self.lb_time.text = text
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func configureTableView() {
        tbHospital.registerNib(UINib(nibName: "HomeCell", bundle: nil), forCellReuseIdentifier: "HomeCell")
        tbHome.registerNib(UINib(nibName: "HomeCell", bundle: nil), forCellReuseIdentifier: "HomeCell")
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == tbHospital {
            let cell = tableView.dequeueReusableCellWithIdentifier("HomeCell", forIndexPath: indexPath) as! HomeCell
            cell.lbPatient.text = "\(self.listMedicar.count)"
            cell.lbSlots.text = "\(self.listHospitalTimmingSlot.count)"
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("HomeCell", forIndexPath: indexPath) as! HomeCell
            cell.lbPatient.text = "\(self.listMedicar.count)"
            cell.lbSlots.text = "\(self.listHomeTimmingSlot.count)"
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
    }
}
