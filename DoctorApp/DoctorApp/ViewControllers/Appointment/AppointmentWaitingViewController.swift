//
//  AppointmentWaitingViewController.swift
//  DoctorApp
//
//  Created by Edward Nguyen on 5/10/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit
import PKHUD

class AppointmentWaitingViewController: UIViewController {

    @IBOutlet var tbAppointment: UITableView!
    var appointments: [CacheModel] = []
    var expandedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        PKHUD.sharedHUD.show()
        AppointmentAPI.getMedicarAppointment(.Waiting, success: { (arr) in
            PKHUD.sharedHUD.hide(animated: false, completion: nil)
            self.appointments = arr
            self.tbAppointment.reloadData()
            }, failure: { code, msg, pars in
                Utils.showOKAlertPanel(self, title: "Rất tiếc", msg: "Không tải được thông tin cuộc hẹn, xin vui lòng thử lại!")
                self.appointments = []
                self.tbAppointment.reloadData()
        })
    }
}

extension AppointmentWaitingViewController: UITableViewDataSource, UITableViewDelegate {
    func configureTableView() {
        tbAppointment.registerNib(UINib(nibName: "AppointmentCell", bundle: nil), forCellReuseIdentifier: "AppointmentCell")
        tbAppointment.registerNib(UINib(nibName: "AppointmentExpandedCell", bundle: nil), forCellReuseIdentifier: "AppointmentExpandedCell")
        
        tbAppointment.rowHeight = UITableViewAutomaticDimension
        tbAppointment.estimatedRowHeight = 100
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.row == expandedIndex ? 240 : 100
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointments.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = (indexPath.row == expandedIndex) ? "AppointmentExpandedCell" : "AppointmentCell"
        let cell: AppointmentCellProtocol = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! AppointmentCellProtocol
        
        let cacheModel = appointments[indexPath.row]
        if let appointment = AppointmentCache.INST.get(cacheModel) {
            cell.waiting(false)
            cell.configure(appointment)
            
            if let expCell = cell as? AppointmentExpandedCell {
                expCell.okHandler = {self.acceptAppointment(appointment)}
                expCell.cancelHandler = {self.rejectAppointment(appointment)}
            }
        }
        else {
            cell.waiting(true)
            cell.configure(nil)
            AppointmentCache.INST.get(cacheModel, fetcher: { appointment in
                if appointment != nil {
                    tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                }
            })
        }
        
        let tableViewCell = cell as! UITableViewCell
        tableViewCell.contentView.setNeedsUpdateConstraints()
        tableViewCell.contentView.updateConstraints()
        
        return tableViewCell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let bufferedCaches = (0..<10).map({indexPath.row + $0}).filter({$0 < appointments.count})
            .map({appointments[$0]})
        
        if !bufferedCaches.isEmpty {
            AppointmentCache.INST.fetch(bufferedCaches, fetcher: nil)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var reloads = [indexPath]
        if (indexPath.row == expandedIndex) {
            expandedIndex = nil
        }
        else {
            if expandedIndex != nil {
                reloads.append(NSIndexPath(forRow: expandedIndex!, inSection: 0))
            }
            
            expandedIndex = indexPath.row
        }
        
        tableView.reloadRowsAtIndexPaths(reloads, withRowAnimation: .Automatic)
    }
    
    func acceptAppointment(appointment: Appointment) {
        PKHUD.sharedHUD.show()
        AppointmentAPI.approveAppointment(appointment.id, result: { succ, code, msg, pars in
            PKHUD.sharedHUD.hide(animated: false, completion: nil)
            
            if succ {
                if let index = self.appointments.indexOf({$0.id == appointment.id}) {
                    self.appointments.removeAtIndex(index)
                    self.tbAppointment.deleteRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: .Automatic)
                }
            }
            else {
                Utils.showOKAlertPanel(self, title: "Lỗi", msg: "Không thể chấp nhận cuộc hẹn! Xin vui lòng thử lại.")
                
            }
        })
    }
    
    func rejectAppointment(appointment: Appointment) {
        PKHUD.sharedHUD.show()
        AppointmentAPI.rejectAppointment(appointment.id, result: { succ, code, msg, pars in
            PKHUD.sharedHUD.hide(animated: false, completion: nil)
            
            if succ {
                if let index = self.appointments.indexOf({$0.id == appointment.id}) {
                    self.appointments.removeAtIndex(index)
                    self.tbAppointment.deleteRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: .Automatic)
                }
            }
            else {
                Utils.showOKAlertPanel(self, title: "Lỗi", msg: "Không thể từ chối cuộc hẹn! Xin vui lòng thử lại.")
            }
        })
    }
}