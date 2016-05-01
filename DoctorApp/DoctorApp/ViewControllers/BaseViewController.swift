//
//  BaseViewController.swift
//  DoctorApp
//
//  Created by Edward Nguyen on 4/30/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    var tap: UITapGestureRecognizer!
    var currentActiveTextEdit: UIView?
    @IBOutlet var sv_mainScrollView: UIScrollView!
    @IBOutlet var lc_scrollViewBottom: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tap = UITapGestureRecognizer(target: self, action: #selector(BaseViewController.dismissKeyboard))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

extension BaseViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if (currentActiveTextEdit == textView) {
            currentActiveTextEdit = nil
        }
    }
}

extension BaseViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        currentActiveTextEdit = nil
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if (currentActiveTextEdit == textField) {
            currentActiveTextEdit = nil
        }
        
    }
}

//MARK: Notification
extension BaseViewController {
    func inputTypeChanged() {
        if (currentActiveTextEdit == nil) {
            return
        }
    }
    
    func hideKeyboard() {
        currentActiveTextEdit?.resignFirstResponder()
    }
}

// MARK: Show/hide keyboard
extension BaseViewController{
    func registerForKeyboardNotifications()
    {
        assert(sv_mainScrollView != nil, "Must assign scrollview to sv_mainScrollView IBOutlet")
        assert(lc_scrollViewBottom != nil, "Must assign scrollview bottom constraint to IBOutlet")
        //Adding notifies on keyboard appearing
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BaseViewController.keyboardWasShown(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BaseViewController.keyboardWillBeHidden(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification)
    {
        //Need to calculate keyboard exact size due to Apple suggestions
        let info : NSDictionary = notification.userInfo!
        let duration = info.objectForKey(UIKeyboardAnimationDurationUserInfoKey) as! NSNumber
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size
        
        lc_scrollViewBottom.constant = keyboardSize!.height
        UIView.animateWithDuration(duration.doubleValue, animations: { () -> Void in
            self.view.layoutIfNeeded()
        }) { (complete) -> Void in
            self.addTapToDismissInput()
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification)
    {
        let info : NSDictionary = notification.userInfo!
        let duration = info.objectForKey(UIKeyboardAnimationDurationUserInfoKey) as! NSNumber
        lc_scrollViewBottom.constant = 0
        UIView.animateWithDuration(duration.doubleValue, animations: { () -> Void in
            self.view.layoutIfNeeded()
        }) { (complete) -> Void in
            self.removeTapToDismissInput()
        }
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
}

extension BaseViewController {
    func addTapToDismissInput() {
        view.addGestureRecognizer(tap)
    }
    
    func removeTapToDismissInput() {
        view.removeGestureRecognizer(tap)
    }
}