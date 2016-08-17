//
//  BaseMenuViewController.swift
//  DoctorApp
//
//  Created by Edward Nguyen on 4/30/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit
import Spring
import PKHUD

class BaseMenuViewController: BaseViewController {
    @IBOutlet var v_navigation: NavigationBarView!
    var v_rightMenu: MenuView!
    var v_overlay: UIView!
    let animationDuration = 0.3
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        if (v_navigation != nil) {
            v_navigation.btn_menu.addTarget(self, action: #selector(BaseMenuViewController.menuClicked(_:)), forControlEvents: .TouchUpInside)
            v_navigation.btn_back.addTarget(self, action: #selector(BaseMenuViewController.backClicked(_:)), forControlEvents: .TouchUpInside)
            self.v_navigation.superview?.bringSubviewToFront(self.v_navigation)
        }
    }
}

//MARK: Action Handler
extension BaseMenuViewController {
    @IBAction func backClicked(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func menuClicked(sender: UIButton) {
        self.view.endEditing(true)
        showMenuView()
    }
}

//MARK: Right menu handler
extension BaseMenuViewController : RightMenuDelegate {
    func showMenuView() {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        if (v_rightMenu == nil) {
            let frame = CGRectMake(screenSize.width - screenSize.width/3, 0, screenSize.width/3, screenSize.height)
            v_rightMenu = MenuView(frame: frame)
            v_rightMenu.delegate = self
            v_rightMenu.view.applyShadow()
        }
        
        addHideMenuTouchRecognizer()
        
        self.view.addSubview(v_rightMenu)
        
        
        let frame = CGRectMake(screenSize.width - screenSize.width/3, 0, screenSize.width/3, screenSize.height)
        v_rightMenu.frame = frame
        v_rightMenu.view.animation = Spring.AnimationPreset.SlideLeft.rawValue
        v_rightMenu.view.curve = Spring.AnimationCurve.EaseIn.rawValue
        v_rightMenu.view.duration = 0.5
        v_rightMenu.view.animate()
    }
    
    func hideMenuClicked() {
        removeHideMenuTouchRecognizer()
        UIView.animateWithDuration(0.3) { () -> Void in
            let screenSize: CGRect = UIScreen.mainScreen().bounds
            let frame = CGRectMake(screenSize.width, 0, screenSize.width/3, screenSize.height)
            self.v_rightMenu.frame = frame
        }
    }
    
    func menu_didSelect(menu: RightMenu) {
        hideMenuClicked()
        
        switch menu {
        case .Home:
            goToHome()
            break
        case .Profile:
            gotoUpdateProfile()
            break
        case .Appointments:
            goToAppointments()
            break
        case .Schedule:
            goToSchedule()
            break
        case .Notification:
            goToNotification()
            break
        case .SignOut:
            signout()
            break
        }
    }
}

//MARK: Navigation
extension BaseMenuViewController {
    func goToHome() {
        if self is HomeViewController { return }
        else { self.navigationController?.popToRootViewControllerAnimated(true) }
    }
    
    func gotoUpdateProfile() {
        let navController = self.navigationController
        let vcDestination = UpdateProfileViewController(nibName: "UpdateProfileViewController", bundle: nil)
        vcDestination.lc_init(Glob.userProfile!)
        navController?.pushViewController(vcDestination, animated: true)
    }
    
    func goToAppointments() {
        let navController = self.navigationController
        let vcDestination = AppointmentViewController(nibName: "AppointmentViewController", bundle: nil)
        navController?.pushViewController(vcDestination, animated: true)
    }
    
    func goToSchedule() {
        let navController = self.navigationController
        let vcDestination = ScheduleViewController(nibName: "ScheduleViewController", bundle: nil)
        navController?.pushViewController(vcDestination, animated: true)
    }
    
    func goToNotification() {
        let navController = self.navigationController
        let vcDestination = NotificationViewController(nibName: "NotificationViewController", bundle: nil)
        navController?.pushViewController(vcDestination, animated: true)
    }
    
    func signout() {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        LoginAPI.logout({ (data) in
            PKHUD.sharedHUD.hide(animated: true, completion: nil)
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.gotoLoginVC()
            Persist.INST.db_wipeDBOnSignout()
            print(data)
        }) { (code, msg, params) in
            PKHUD.sharedHUD.hide(animated: true, completion: nil)
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.gotoLoginVC()
            Persist.INST.db_wipeDBOnSignout()
        }
        
        API.api1.auth = API.Auth()
        API.api2.auth = API.Auth()
        
        NSUserDefaults.standardUserDefaults().removeObjectForKey(HC.REFRESH_TOKEN)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}

//MARK: Gesture handler
extension BaseMenuViewController {
    func addHideMenuTouchRecognizer() {
        if v_overlay == nil {
            let tapOverLay = UITapGestureRecognizer(target: self, action: #selector(BaseMenuViewController.handleTap))
            v_overlay = UIView(frame: self.view.frame)
            v_overlay.backgroundColor = Utils.UIColorFromRGB(red: 100, green: 100, blue: 100)
            v_overlay.addGestureRecognizer(tapOverLay)
        }
        
        v_overlay.alpha = 0
        self.view.addSubview(v_overlay)
        
        UIView.animateWithDuration(animationDuration) { () -> Void in
            self.v_overlay.alpha = 0.8
        }
    }
    
    func removeHideMenuTouchRecognizer() {
        UIView.animateWithDuration(animationDuration, animations: { () -> Void in
            self.v_overlay.alpha = 0
        }) { (complete) -> Void in
            self.v_overlay.removeFromSuperview()
        }
    }
    
    func handleTap() {
        hideMenuClicked()
    }
}
