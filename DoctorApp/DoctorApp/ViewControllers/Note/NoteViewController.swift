//
//  PrescriptionViewController.swift
//  DoctorApp
//
//  Created by Edward Nguyen on 5/7/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit

class NoteViewController: BaseTabViewController {
    
    var appointmentId: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Do any additional setup after loading the view.
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

extension NoteViewController: BaseTabViewControllerDelegate{
    func tabViewWillClose(index: Int, tab: UIViewController?) {
        
    }
    
    func tabViewDidChanged(index: Int, tab: UIViewController?) {
        tab?.view.endEditing(true)
    }
    
    func createViewControllerForTabButton(btn: UIButton, atIndex index: Int) -> UIViewController? {
        switch (index) {
        case 0:
            let dentisnation_vc = ClinicalViewController(nibName:"ClinicalViewController", bundle: nil)
            dentisnation_vc.appointmentId = appointmentId
            return dentisnation_vc
        case 1:
            let dentisnation_vc = PrescriptionViewController(nibName: "PrescriptionViewController", bundle: nil)
            dentisnation_vc.appointmentId = appointmentId
            dentisnation_vc.delegate = self
            return dentisnation_vc
        default:
            return nil
        }
    }
}

extension NoteViewController: PrescriptionViewControllerDelegate {
    func goBack() {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
