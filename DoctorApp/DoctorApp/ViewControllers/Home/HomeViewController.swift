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
    @IBOutlet var tb_clinics: UITableView!
    @IBOutlet var vtop: UIView!
    @IBOutlet var v_ailmentContainer: BorderedView!
    @IBOutlet var img_doctor: UIImageView!
    @IBOutlet weak var lb_time: UILabel!

    private var hardCodedTableViewRowCount : Int!
    private var hardCodedTableViewSectionCount : Int!
    private var hardCodedTableViewSectionHeaderHeight : CGFloat!
    private var hardCodedTableViewSectionFooterHeight : CGFloat!
    private var hardCodedTableViewRowHeight : CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        hardCodedTableViewRowCount = 5
        hardCodedTableViewSectionCount = 5
        hardCodedTableViewSectionHeaderHeight = 45
        hardCodedTableViewSectionFooterHeight = 20
        hardCodedTableViewRowHeight = 100

        setupNavigationBar()
        
        configureTableView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setupLayout()
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
        var totalViewHeight : CGFloat = 0
        var tableViewHeight : CGFloat = 0
        
        //add total footer and header height
        
        tableViewHeight += CGFloat(3) * hardCodedTableViewSectionFooterHeight
        tableViewHeight += CGFloat(3) * hardCodedTableViewSectionHeaderHeight
        
        for _ : Int in 0 ..< 3
        {
            //add total height of rows for each section
            tableViewHeight += CGFloat(3) * hardCodedTableViewRowHeight
        }
        
        totalViewHeight += tableViewHeight
        totalViewHeight += vtop.frame.size.height
        totalViewHeight += v_ailmentContainer.frame.size.height
        totalViewHeight += 50 * 2   // gap size between notification view + ailment view
        
        tb_clinics.frame = CGRect(origin: tb_clinics.frame.origin,
                                  size: CGSize(width: tb_clinics.frame.size.width, height: tableViewHeight))
        
        sv_container.contentSize = CGSize(width: sv_container.contentSize.width,
                                          height: totalViewHeight)
    }
}
//MARK: Set Layout
extension HomeViewController{
    func setupLayout(){
        self.lb_welcome.text = "Xin chào, bác sĩ A!"
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
        
        let text = "Today, \(formatter.stringFromDate(time))"
        self.lb_time.text = text
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func configureTableView() {
        tb_clinics.registerNib(UINib(nibName: "HomeCell", bundle: nil), forCellReuseIdentifier: "HomeCell")
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeCell", forIndexPath: indexPath) as! HomeCell
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return hardCodedTableViewSectionHeaderHeight
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return hardCodedTableViewSectionFooterHeight
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 20))
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
    }
}
