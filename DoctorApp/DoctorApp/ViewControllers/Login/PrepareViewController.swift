//
//  PrepareViewController.swift
//  PatientApp
//
//  Created by Salm on 7/4/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit
import StoreKit

class PrepareViewController: UIViewController, SKStoreProductViewControllerDelegate {

    @IBOutlet weak var ivLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        checkVersion()
    }
    
    func checkVersion() {
        VersionAPI.checkVersion({ succ, _, _, _ in
            if (succ) {
                self.gotoApp()
            }
            else {
                Utils.showOKAlertPanel(self, title: "Phiên bản cũ", msg: "Phiên bản bạn đang dùng đã cũ. Xin vui lòng nâng cấp phiên bản mới.",
                    callback: { _ in
                        self.openStoreProductWithiTunesItemIdentifier(HC.APP_ID)
                })
            }
        });
    }
    
    func gotoApp() {
        if let refreshToken = NSUserDefaults.standardUserDefaults().objectForKey(HC.REFRESH_TOKEN) as? String {
            LoginAPI.getAccessToken(refreshToken, success: { _resp in
                if (_resp == nil) {
                    self.gotoLoginViewControllerAndDismissRefreshToken()
                    return;
                }
                
                let resp = _resp!
                
                API.api1.auth = API.Auth(sess: resp.token.accessToken)
                API.api2.auth = API.Auth(sess: resp.token.accessToken)
                
                ProfileAPI.getUserProfile({ profile in
                    if let profile = profile {
                        Glob.userProfile = profile
                        
                        let nav_mainApp = UINavigationController()
                        let vc_dashboard = HomeViewController(nibName: "HomeViewController", bundle: nil)
                        nav_mainApp.viewControllers = [vc_dashboard]
                        nav_mainApp.setNavigationBarHidden(true, animated: false)
                        
                        self.presentViewController(nav_mainApp, animated: true, completion: nil)
                    }
                    else {
                        self.gotoLoginViewControllerAndDismissRefreshToken()
                    }
                    
                    }, failure: { _, _, _ in
                        self.gotoLoginViewControllerAndDismissRefreshToken()
                })
                }, failure: { _, _, _ in
                    self.gotoLoginViewControllerAndDismissRefreshToken()
            })
        }
        else {
            self.gotoLoginViewControllerAndDismissRefreshToken()
        }
    }
    
    func gotoLoginViewControllerAndDismissRefreshToken() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(HC.REFRESH_TOKEN)
        NSUserDefaults.standardUserDefaults().synchronize()
        
        let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil);
        self.gotoViewController(loginVC)
    }

    func gotoViewController(vc: UIViewController) {
        UIView.animateWithDuration(HC.ANIM_DUR_DEFAULT, animations: {
            self.ivLogo.alpha = 0
            }, completion: { _ in
                let vc_initial = LoginViewController(nibName: "LoginViewController", bundle: nil)
                
                let c_navigation = UINavigationController(rootViewController: vc_initial)
                c_navigation.setNavigationBarHidden(true, animated: false)
                
                let window = UIApplication.sharedApplication().delegate?.window!
                window?.rootViewController = c_navigation
                window?.makeKeyAndVisible()
        })
    }
    
    func openStoreProductWithiTunesItemIdentifier(identifier: String) {
        let storeViewController = SKStoreProductViewController()
        storeViewController.delegate = self
        
        let parameters = [ SKStoreProductParameterITunesItemIdentifier : identifier]
        storeViewController.loadProductWithParameters(parameters) { [weak self] (loaded, error) -> Void in
            if loaded {
                // Parent class of self is UIViewContorller
                self?.presentViewController(storeViewController, animated: true, completion: nil)
            }
        }
    }
    
    func productViewControllerDidFinish(viewController: SKStoreProductViewController) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
}

//extension PrepareViewController: LCViewControllerProtocol {
//    var showNavBar: Bool {
//        return false
//    }
//}
