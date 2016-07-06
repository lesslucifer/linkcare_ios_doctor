//
//  LoginViewController.swift
//  DoctorApp
//
//  Created by Edward Nguyen on 4/30/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit
import PKHUD
import GoogleMaterialIconFont

class LoginViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate {
    
    @IBOutlet var scrollView : UIScrollView!
    @IBOutlet var tfUsername: UITextField!
    @IBOutlet var tfPassword: UITextField!
    @IBOutlet weak var btnShowPassword: UIButton!
    
    var activeField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        btnShowPassword.titleLabel?.font = UIFont.materialIconOfSize(20);
        btnShowPassword.setTitle(String.materialIcon(.RemoveRedEye), forState: .Normal)
        
        registerForKeyboardNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        setupLayout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupLayout() {
//        tfUsername.underlineTextField()
//        tfPassword.underlineTextField()
    }
    
    func registerForKeyboardNotifications()
    {
        //Adding notifies on keyboard appearing
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWasShown(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillBeHidden(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification){
        
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        keyboardFrame = self.view.convertRect(keyboardFrame, fromView: nil)
        
        var contentInset:UIEdgeInsets = scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }
    
    func keyboardWillBeHidden(notification: NSNotification){
        
        let info : NSDictionary = notification.userInfo!
        let keyboardSize = info.objectForKey(UIKeyboardFrameBeginUserInfoKey)?.frame
        let heightInsets = (keyboardSize == nil) ? 0.0 : keyboardSize!.height
        let insets: UIEdgeInsets = UIEdgeInsetsMake(scrollView.contentInset.top, 0, heightInsets, 0)
        
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        activeField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        activeField = nil
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //MARK: Action handler
    @IBAction func loginPressed(sender: AnyObject) {
        let nav_mainApp = UINavigationController()
        let vc_dashboard = HomeViewController(nibName: "HomeViewController", bundle: nil)
        
        HUD.show(.Progress)
        LoginAPI.login(self.tfUsername.text!, password: self.tfPassword.text!, success: { (loginResp) in
            HUD.hide()
            if let session = loginResp?.session where loginResp!.roles.contains({$0.code == "DOCTOR_ROLE" || $0.code == "NURSE_ROLE"}) {
                API.api1.auth = API.Auth(sess: session)
                nav_mainApp.viewControllers = [vc_dashboard]
                nav_mainApp.setNavigationBarHidden(true, animated: false)
                
                self.presentViewController(nav_mainApp, animated: true, completion: nil)
            }
            else {
                Utils.showOKAlertPanel(self, title: "Lỗi", msg: "Tài khoản hoặc mật khẩu không chính xác! Xin vui lòng thử lại.")
            }
            
            }, failure: { code, msg, params in
                HUD.hide()
                Utils.showOKAlertPanel(self, title: "Lỗi", msg: "Tài khoản hoặc mật khẩu không chính xác! Xin vui lòng thử lại.")
        })
        
    }
    
    @IBAction func forgotPasswordPressed(sender: AnyObject) {
        let resetPasswordVC = ResetPasswordViewController(nibName: "ResetPasswordViewController", bundle: nil)
        let popup = self.rootVC?.showPopup(resetPasswordVC, heightRatio: 0.9, widthRatio: 0.4)
        resetPasswordVC.onClose = { _ in
            self.rootVC?.closePopup(popup!)
        }
    }
    
    @IBAction func notSupported(sender: AnyObject) {
        Utils.showOKAlertPanel(self, title: "Chưa hỗ trợ", msg: "Chúng tôi đang cố gắng hoàn thiện tính năng này,  mong bạn thông cảm!")
    }
    
    @IBAction func btnShowPasswordTouchedDown(sender: AnyObject) {
        self.tfPassword.secureTextEntry = false;
    }
    
    @IBAction func btnShowPasswordTouchedUp(sender: AnyObject) {
        self.tfPassword.secureTextEntry = true;
    }
}