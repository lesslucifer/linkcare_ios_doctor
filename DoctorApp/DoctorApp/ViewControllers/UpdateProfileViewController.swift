//
//  UpdateProfileViewController.swift
//  PatientApp
//
//  Created by Salm on 7/4/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit
import PKHUD
import SwiftDate

class UpdateProfileViewController: BaseMenuViewController {

    @IBOutlet weak var svContent: UIScrollView!
    
    @IBOutlet weak var tfIDCard: UITextField!
    
    @IBOutlet weak var tfOldPassword: UITextField!
    @IBOutlet weak var tfNewPassword: UITextField!
    @IBOutlet weak var tfConfirmPassword: UITextField!
    @IBOutlet weak var btnChangePassword: UIButton!
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfBirthday: UITextField!
    @IBOutlet weak var scGender: UISegmentedControl!
    @IBOutlet weak var tfAddress: UITextField!
    @IBOutlet weak var btnMap: UIButton!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPhoneNumber: UITextField!
    @IBOutlet weak var btnUpdateProfile: UIButton!
    
    @IBOutlet weak var lcBottom: NSLayoutConstraint!
    
    private let textBinder = TextBinder()
    private var keyboardHandler: KeyboardHandler!
    
    private var userProfile: UserProfile!
    
    func lc_init(profile: UserProfile) {
        self.userProfile = profile
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.dismissKeyboardOnTap()
        
        self.keyboardHandler = KeyboardHandler(view: self.svContent, bottomConstr: self.lcBottom)
        self.setupTextFields()
        
        self.btnMap.titleLabel?.font = UIFont.materialIconOfSize(28)
        self.btnMap.setTitle(String.materialIcon(.Place), forState: .Normal)
        btnChangePassword.linkcarelize()
        btnUpdateProfile.linkcarelize()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.keyboardHandler.attachListener()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.keyboardHandler.removeListener()
    }
    
    func setupTextFields() {
        tfIDCard.addUnderline(color: LCColor.LightCyan)
        tfOldPassword.addUnderline(color: LCColor.LightCyan)
        tfNewPassword.addUnderline(color: LCColor.LightCyan)
        tfConfirmPassword.addUnderline(color: LCColor.LightCyan)
        tfName.addUnderline(color: LCColor.LightCyan)
        tfBirthday.addUnderline(color: LCColor.LightCyan)
        tfAddress.addUnderline(color: LCColor.LightCyan)
        tfEmail.addUnderline(color: LCColor.LightCyan)
        tfPhoneNumber.addUnderline(color: LCColor.LightCyan)
        
        textBinder.bindTextField(tfOldPassword, shouldReturn: TextBinder.DismissKeyboardOnReturn)
        textBinder.bindTextField(tfNewPassword, shouldReturn: TextBinder.DismissKeyboardOnReturn)
        textBinder.bindTextField(tfConfirmPassword, shouldReturn: TextBinder.DismissKeyboardOnReturn)
        textBinder.bindTextField(tfName, shouldReturn: TextBinder.DismissKeyboardOnReturn)
        textBinder.bindTextField(tfAddress, shouldReturn: TextBinder.DismissKeyboardOnReturn)
        textBinder.bindTextField(tfEmail, shouldReturn: TextBinder.DismissKeyboardOnReturn)
        textBinder.bindTextField(tfPhoneNumber, shouldReturn: TextBinder.DismissKeyboardOnReturn)
        
        tfIDCard.text = userProfile.idCard
        tfName.text = userProfile.fullName
        tfBirthday.text = DateFormat.dateDotFormatter.stringFromDate(userProfile.birthDay)
        scGender.selectedSegmentIndex = userProfile.sex.rawValue
        tfAddress.text = userProfile.address
        tfEmail.text = userProfile.email
        tfPhoneNumber.text = userProfile.phoneNumber
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        
        //        v_navigation.addBackButton()
        v_navigation.setTitle("NGƯỜI DÙNG")
    }
    
    @IBAction func btnChangePasswordPressed(sender: AnyObject) {
        let oldPassword = tfOldPassword.text!
        if (Utils.isEmpty(oldPassword)) {
            Utils.showOKAlertPanel(self, title: "Lỗi", msg: "Bạn phải nhập mật khẩu cũ")
            return
        }
        
        let newPassword = tfNewPassword.text!
        let confirmPassword = tfConfirmPassword.text!;
        
        if (newPassword.characters.count < 6) {
            Utils.showOKAlertPanel(self, title: "Lỗi", msg: "Mật khẩu mới phải có ít nhất 6 ký tự")
            return
        }
        
        if (newPassword != confirmPassword) {
            Utils.showOKAlertPanel(self, title: "Lỗi", msg: "Mật khẩu nhập lại chưa chính xác")
            return
        }
        
        HUD.show(.Progress)
        UpdateProfileAPI.changePassword(oldPassword, newPassword: newPassword, result: { succ, _, _, _ in
            HUD.hide()
            if (succ) {
                Utils.showOKAlertPanel(self, title: "Thành công", msg: "Đổi mật khẩu thành công")
                self.tfOldPassword.text = ""
                self.tfNewPassword.text = ""
                self.tfConfirmPassword.text = ""
                return
            }
            else {
                Utils.showOKAlertPanel(self, title: "Thất bại", msg: "Đổi mật khẩu thất bại. Xin vui lòng thử lại.")
            }
        })
    }
    
    @IBAction func btnUpdateProfilePressed(sender: AnyObject) {
        let updateProfile = UpdateProfileSubmit()
        
        if (Utils.isEmpty(self.tfEmail.text)) {
            Utils.showOKAlertPanel(self, title: "Lỗi", msg: "Bạn phải nhập email của bạn")
            return
        }
        
        if (userProfile.email != tfEmail.text!) {
            updateProfile.email = tfEmail.text
        }
        
        if (userProfile.phoneNumber != tfPhoneNumber.text!) {
            updateProfile.phoneNumber = tfPhoneNumber.text
        }
        
        self.doUpdateProfile(updateProfile)
    }
    
    func doUpdateProfile(updateProfile: UpdateProfileSubmit) {
        HUD.show(.Progress)
        UpdateProfileAPI.updateProfile(updateProfile, result: { succ, _, _, _ in
            HUD.hide()
            if (succ) {
                Utils.showOKAlertPanel(self, title: "Thành công", msg: "Cập nhật thông tin tài khoản thành công")
                self.updateProfileToUserProfile(updateProfile)
            }
            else {
                Utils.showOKAlertPanel(self, title: "Thất bại", msg: "Cập nhật thông tin tài khoản thất bại. Xin vui lòng thử lại.")
            }
        })
    }
    
    func updateProfileToUserProfile(updateProfile: UpdateProfileSubmit) {
        if !Utils.isEmpty(updateProfile.fullName) {
            userProfile.fullName = updateProfile.fullName
        }
        
        if let birthday = updateProfile.birthday {
            userProfile.birthDay = birthday
        }
        
        if let gender = updateProfile.gender {
            userProfile.sex = gender
        }
        
        if let email = updateProfile.email {
            userProfile.email = email
        }
        
        if let phoneNumber = updateProfile.phoneNumber {
            userProfile.phoneNumber = phoneNumber
        }
        
        if let address = updateProfile.address {
            userProfile.address = address.address
            userProfile.longtitude = address.longitude
            userProfile.latitude = address.latitude
        }
    }
}