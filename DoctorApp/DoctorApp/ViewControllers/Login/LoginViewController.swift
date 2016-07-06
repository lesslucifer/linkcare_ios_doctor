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
    @IBOutlet weak var btnSavePassword: UIButton!
    
    var activeField: UITextField?
    var isSavePassword: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        tfUsername.addUnderline(color: LCColor.LightCyan)
        tfPassword.addUnderline(color: LCColor.LightCyan)
        btnSavePassword.layer.borderColor = LCColor.LightCyan.CGColor
        btnSavePassword.layer.borderWidth = 1
        btnSavePassword.layer.cornerRadius = 3
        
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
        view.endEditing(true)
    }
    
    //MARK: Action handler
    @IBAction func loginPressed(sender: AnyObject) {
        HUD.show(.Progress)
        LoginAPI.login2(self.tfUsername.text!, password: self.tfPassword.text!, success: { (_resp) in
            if (_resp == nil) {
                HUD.hide();
                Utils.showOKAlertPanel(self, title: "Lỗi", msg: "Tài khoản hoặc mật khẩu không chính xác! Xin vui lòng thử lại.")
                return;
            }
            
            let resp = _resp!
            
            if (!resp.roles.contains({$0.code == "DOCTOR_ROLE" || $0.code == "NURSE_ROLE"})) {
                HUD.hide();
                Utils.showOKAlertPanel(self, title: "Lỗi", msg: "Tài khoản hoặc mật khẩu không chính xác! Xin vui lòng thử lại.")
            }
            
            API.api1.auth = API.Auth(sess: resp.tokens.accessToken)
            API.api2.auth = API.Auth(sess: resp.tokens.accessToken)
            
            // save refresh token
            if (self.isSavePassword) {
                NSUserDefaults.standardUserDefaults().setObject(resp.tokens.refreshToken, forKey: HC.REFRESH_TOKEN)
            }
            else {
                NSUserDefaults.standardUserDefaults().removeObjectForKey(HC.REFRESH_TOKEN)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
            
            ProfileAPI.getUserProfile({ profile in
                HUD.hide()
                
                if let profile = profile {
                    Glob.userProfile = profile
                    
                    let nav_mainApp = UINavigationController()
                    let vc_dashboard = HomeViewController(nibName: "HomeViewController", bundle: nil)
                    nav_mainApp.viewControllers = [vc_dashboard]
                    nav_mainApp.setNavigationBarHidden(true, animated: false)
                    
                    self.presentViewController(nav_mainApp, animated: true, completion: nil)
                }
                else {
                    Utils.showOKAlertPanel(self, title: "Lỗi", msg: "Không tải được thông tin tài khoản, xin vui lòng thử lại!")
                }
                
                }, failure: { _, _, _ in
                    HUD.hide()
                    Utils.showOKAlertPanel(self, title: "Lỗi", msg: "Không tải được thông tin tài khoản, xin vui lòng thử lại!")
            })
            
            }, failure: { code, msg, params in
                HUD.hide()
                Utils.showOKAlertPanel(self, title: "Lỗi", msg: "Tài khoản hoặc mật khẩu không chính xác!")
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
    
    @IBAction func btnSavePasswordPressed(sender: AnyObject) {
        isSavePassword = !isSavePassword
        updateSavePassword()
    }
    
    func updateSavePassword() {
        let title = isSavePassword ? "✓" : ""
        btnSavePassword.setTitle(title, forState: .Normal)
    }
}