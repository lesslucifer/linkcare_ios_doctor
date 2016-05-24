//
//  AppointmentViewController.swift
//  DoctorApp
//
//  Created by Edward Nguyen on 4/29/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import Foundation
import UIKit

class AppointmentViewController: BaseTabViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        setupNavigationBar()
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
    
}

extension AppointmentViewController: BaseTabViewControllerDelegate{
    func tabViewWillClose(index: Int, tab: UIViewController?) {
        
    }
    
    func tabViewDidChanged(index: Int, tab: UIViewController?) {
        tab?.view.endEditing(true)
    }
    
    func createViewControllerForTabButton(btn: UIButton, atIndex index: Int) -> UIViewController? {
        switch (index) {
        case 0:
            return AppointmentWaitingViewController(nibName:"AppointmentWaitingViewController", bundle: nil)
        case 1:
            let dentisnation_vc = AppointmentApproveViewController(nibName: "AppointmentApproveViewController", bundle: nil)
            dentisnation_vc.delegate = self
            return dentisnation_vc
        case 2:
            let dentisnation_vc = AppointmentStartViewController(nibName: "AppointmentStartViewController", bundle: nil)
            dentisnation_vc.delegate = self
            return dentisnation_vc
        default:
            return nil
        }
    }
}

extension AppointmentViewController: AppointmentStartViewControllerDelegate, AppointmentApproveViewControllerDelegate {
    func notedClicked(appointmentId: Int) {
        let storyboard = UIStoryboard(name: "NoteStoryboard", bundle: nil)
        let vc_destination = storyboard.instantiateViewControllerWithIdentifier("noteDashboard") as! NoteViewController
        vc_destination.appointmentId = appointmentId
        self.navigationController?.pushViewController(vc_destination, animated: true)
    }
}
