//
//  MMKeyboardHandler.swift
//  MyMediSquare Doctor
//
//  Created by Vinova on 2/17/16.
//  Copyright © 2016 Vinova. All rights reserved.
//

import UIKit

class KeyboardHandler: NSObject {
    weak var view: UIView!
    weak var bottomConstraint: NSLayoutConstraint!
    private var oldConst: CGFloat = 0
    private var keyboardHeight: CGFloat = 0
    
    var keyboardWasShown: ((Bool) -> Void)?
    var keyboardWasHidden: ((Bool) -> Void)?
    
    required init(view: UIView, bottomConstr: NSLayoutConstraint) {
        self.view = view
        self.bottomConstraint = bottomConstr
    }
    
    func attachListener() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(KeyboardHandler.keyboardWasShown(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(KeyboardHandler.keyboardWillBeHidden(_:)), name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(KeyboardHandler.keyboardWillChangeFrameNotification(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    func removeListener() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWasShown(notification: NSNotification)
    {
        //Need to calculate keyboard exact size due to Apple suggestions
        let info : NSDictionary = notification.userInfo!
        let duration = info.objectForKey(UIKeyboardAnimationDurationUserInfoKey) as! NSNumber
        let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue().size
        keyboardHeight = max(keyboardSize!.height, keyboardHeight)
        
        let frame = view.convertRect(view.bounds, toView: nil)
        let screenHeight = view.window!.frame.size.height
        let bottomGap = screenHeight - frame.origin.y - frame.size.height
        
        //---
        oldConst = bottomConstraint.constant
        bottomConstraint.constant = keyboardHeight - bottomGap + oldConst + 10
        UIView.animateWithDuration(duration.doubleValue, animations: {
            self.view.layoutIfNeeded()
            }, completion: { finished in
                self.keyboardWasShown?(finished)
        })
    }
    
    func keyboardWillBeHidden(notification: NSNotification)
    {
        let info : NSDictionary = notification.userInfo!
        let duration = info.objectForKey(UIKeyboardAnimationDurationUserInfoKey) as! NSNumber
        //---
        bottomConstraint.constant = oldConst
        UIView.animateWithDuration(duration.doubleValue, animations: {
            self.view.layoutIfNeeded()
            }, completion: { finished in
                self.keyboardWasHidden?(finished)
        })
    }
    
    func keyboardWillChangeFrameNotification(notification: NSNotification) {
        let info : NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue().size
        self.keyboardHeight = keyboardSize!.height
    }
}
