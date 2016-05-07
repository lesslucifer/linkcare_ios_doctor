//
//  PrescriptionViewController.swift
//  DoctorApp
//
//  Created by Edward Nguyen on 5/7/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit

protocol BaseTabViewControllerDelegate{
    func tabViewWillClose(index: Int, tab: UIViewController?)
    func tabViewDidChanged(index: Int, tab: UIViewController?)
    func createViewControllerForTabButton(btn: UIButton, atIndex index: Int) -> UIViewController?
}

class BaseTabViewController: BaseMenuViewController {
    var delegate: BaseTabViewControllerDelegate?
    
    var selectedTabIndex = -1
    @IBOutlet var v_placeholder: ContainerView!
    @IBOutlet var a_tabBarButtons: Array<UIButton>!
    //---
    private var tabViewControllers = [UIButton: UIViewController]()
    //---
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        Utils.invokeLater {
            self.selectTab(0)
        }
            
        for btn in self.a_tabBarButtons {
            btn.addTarget(self, action: #selector(BaseTabViewController.tabButtonPressed(_:)), forControlEvents: .TouchUpInside)
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    func tabButtonPressed(sender: UIButton?) {
        if let index = self.a_tabBarButtons.indexOf(sender!) {
            self.selectTab(index)
        }
    }
    
    func selectTab(index: Int) {
        if selectedTabIndex == index {
            return
        }
        
        let btn = a_tabBarButtons[index]
        if tabViewControllers[btn] == nil {
            tabViewControllers[btn] = self.delegate?.createViewControllerForTabButton(btn, atIndex: index)
        }
        
        let tabVC = tabViewControllers[btn]
        self.delegate?.tabViewWillClose(selectedTabIndex, tab: self.v_placeholder.embededController)
        self.v_placeholder.embedViewController(tabVC)
        selectedTabIndex = index
        self.delegate?.tabViewDidChanged(index, tab: tabVC)
        self.refreshTabButton()
    }
}

extension BaseTabViewController{
    func refreshTabButton() {
        for i in 0..<a_tabBarButtons.count {
            let btn = a_tabBarButtons[i]
            
            if (i == selectedTabIndex) {
                btn.backgroundColor = UIColor.yellowColor()
                btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            }
            else {
                btn.backgroundColor = UIColor.whiteColor()
                btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
            }
        }
    }
}
