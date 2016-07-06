//
//  ResetPasswordViewController.swift
//  PatientApp
//
//  Created by Salm on 7/3/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit
import PKHUD

class ResetPasswordViewController: UIViewController {

    var onClose: ((Bool)->Void)?
    
    @IBOutlet weak var vInput: UIView!
    @IBOutlet weak var tfIdCard: UITextField!
    @IBOutlet weak var btnSend: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tfIdCard.addUnderline(color: LCColor.LightCyan)
        
        let tapRecog = UITapGestureRecognizer(target: self, action: #selector(onTap))
        self.view.addGestureRecognizer(tapRecog)
    }
    
    func onTap(sender: AnyObject?) {
        self.view.endEditing(true)
    }

    
    @IBAction func btnSendPressed(sender: AnyObject) {
        if (tfIdCard.text == nil || tfIdCard.text?.characters.count < 9) {
            Utils.showOKAlertPanel(self, title: "Lỗi", msg: "Số CMND / Hộ Chiếu phải có tối thiểu 9 ký tự.")
            return;
        }
        
        let idCard = tfIdCard.text!
        
        HUD.show(.Progress)
        ResetPasswordAPI.sendResetPasswordRequest(idCard, result: { succ, _, _, _ in
            HUD.hide()
            if (succ) {
                Utils.showOKAlertPanel(self, title: "Thành Công", msg: "Gửi yêu cầu thành công. Vui lòng kiểm tra email đăng ký và làm theo hướng dẫn.",
                    callback: { _ in
                    self.onClose?(true)
                })
            }
            else {
                Utils.showOKAlertPanel(self, title: "Lỗi", msg: "Không gửi được yêu cầu. Xui vui lòng kiểm tra và thử lại.")
            }
        });
    }
    
    @IBAction func btnCancelPressed(sender: AnyObject) {
        self.onClose?(false)
    }
}
