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
    @IBOutlet weak var lbTime: UILabel!

    var profile = UserProfile()
    var listHospitalTimmingSlot:[TimmingSlot] = []
    var listHomeTimmingSlot:[TimmingSlot] = []
    var patientHospital = AppointmentType()
    var patientHome = AppointmentType()
    var tempTimer: NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        setupNavigationBar()
        configureTableView()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        loadProfileData()
        
        loadMedicarTimmingSlot()
        
        loadPatientHospital(0)
        loadPatientHospital(1)
        
        self.tempTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(HomeViewController.updateTime), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tempTimer.invalidate()
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

//MARK: Load data
extension HomeViewController {
    func loadProfileData() {
        ProfileAPI.getUserProfile({ (obj) in
            print(obj)
            self.profile = obj!
            
            self.setupLayout()
        }) { (code, msg, params) in
            
        }
    }
    
    func loadMedicarTimmingSlot() {
        let date = NSDate()
        
        TimingSlotAPI.getMedicarTimingSlot(date, success: { (arr) in
            self.listHospitalTimmingSlot = arr.filter({ $0.type == 0 && $0.available})
            self.listHomeTimmingSlot = arr.filter({ $0.type == 1 && $0.available})
            self.tbHome.reloadData()
            self.tbHospital.reloadData()
            }, failure: { code, msg, pars in
                self.listHospitalTimmingSlot = []
                self.tbHome.reloadData()
                self.tbHospital.reloadData()
        })
    }
    
    func loadPatientHospital(type: Int) {
        let date = NSDate()
        
        AppointmentAPI.getMedicarAppointmentByType(type, date: date, success: { (obj) in
            if type == 0 {
                self.patientHospital = obj!
                self.tbHospital.reloadData()
            } else if type == 1 {
                self.patientHome = obj!
                self.tbHospital.reloadData()
            }
        }) { (code, msg, params) in
            print(msg)
        }
    }
}

//MARK: Set Layout
extension HomeViewController{
    func setupLayout(){
        self.lb_welcome.text = "Xin chào, \(Glob.major?.str() ?? Major.Doctor.str()) \(profile.fullName)!"
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
        self.lbTime.text = text
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
            cell.lbPatient.text = "\(self.patientHospital.count)"
            cell.lbSlots.text = "\(self.listHospitalTimmingSlot.count)"
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("HomeCell", forIndexPath: indexPath) as! HomeCell
            cell.lbPatient.text = "\(self.patientHome.count)"
            cell.lbSlots.text = "\(self.listHomeTimmingSlot.count)"
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
    }
}
