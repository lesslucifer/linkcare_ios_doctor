//
//  MMTextBinder.swift
//  MyMediSquare Doctor
//
//  Created by Vinova on 1/14/16.
//  Copyright © 2016 Vinova. All rights reserved.
//

import UIKit

enum MMTextBinderEvent {
    case ShouldBeginEditing
    case DidBeginEditing
    case ShouldEndEditing
    case ShouldChangeCharactersInRange
    case TextShouldChange
    case ShouldClear
    case ShuldReturn
}

class TextBinder: NSObject {
    typealias TextFieldShouldBeginEditingFunction = (textField: UITextField) -> Bool
    typealias TextFieldDidBeginEditingFunction = (textField: UITextField) -> Void
    typealias TextFieldShouldEndEditingFunction = (textField: UITextField) -> Bool
    typealias TextFieldDidEndEditingFunction = (textField: UITextField) -> Void
    typealias TextFieldShouldChangeCharactersInRangeFunction = (textField: UITextField, range: NSRange, replaceString: String) -> Bool
    typealias TextFieldShouldChangeFunction = (textField: UITextField, text: String?) -> Bool
    typealias TextFieldShouldClearFunction = (textField: UITextField) -> Bool
    typealias TextFieldShouldReturnFunction = (textField: UITextField) -> Bool
    
    private class Binder {
        var shouldBeginEditing: TextFieldShouldBeginEditingFunction?
        var didBeginEditing: TextFieldDidBeginEditingFunction?
        var shouldEndEditing: TextFieldShouldEndEditingFunction?
        var didEndEditing: TextFieldDidEndEditingFunction?
        var shouldChangeCharacterInRange: TextFieldShouldChangeCharactersInRangeFunction?
        var textShouldChange: TextFieldShouldChangeFunction?
        var shouldClear: TextFieldShouldClearFunction?
        var shouldReturn: TextFieldShouldReturnFunction?
        
        var isEmpty: Bool {
            return (shouldBeginEditing == nil) &&
                (didBeginEditing == nil) &&
                (shouldEndEditing == nil) &&
                (didEndEditing == nil) &&
                (shouldChangeCharacterInRange == nil) &&
                (textShouldChange == nil) &&
                (shouldClear == nil) &&
                (shouldReturn == nil)
        }
    }
    
    private var binds = [UITextField: Binder]()
    
    private func getBinderForTextField(textField: UITextField) -> Binder {
        textField.delegate = self
        
        if let binder = binds[textField] {
            return binder
        }
        
        let binder = Binder()
        binds[textField] = binder
        return binder
    }
    
    func bindTextField(textField: UITextField, shouldBeginEditing: TextFieldShouldBeginEditingFunction?) {
        let binder = self.getBinderForTextField(textField)
        binder.shouldBeginEditing = shouldBeginEditing
    }
    
    func bindTextField(textField: UITextField, didBeginEditing: TextFieldDidBeginEditingFunction?) {
        let binder = self.getBinderForTextField(textField)
        binder.didBeginEditing = didBeginEditing
    }
    
    
    func bindTextField(textField: UITextField, shouldEndEditing: TextFieldShouldEndEditingFunction?) {
        let binder = self.getBinderForTextField(textField)
        binder.shouldEndEditing = shouldEndEditing
    }
    
    
    func bindTextField(textField: UITextField, didEndEditing: TextFieldDidEndEditingFunction?) {
        let binder = self.getBinderForTextField(textField)
        binder.didEndEditing = didEndEditing
    }
    
    
    func bindTextField(textField: UITextField, shouldChangeCharacterInRange: TextFieldShouldChangeCharactersInRangeFunction?) {
        let binder = self.getBinderForTextField(textField)
        binder.shouldChangeCharacterInRange = shouldChangeCharacterInRange
    }
    
    
    func bindTextField(textField: UITextField, textShouldChange: TextFieldShouldChangeFunction?) {
        let binder = self.getBinderForTextField(textField)
        binder.textShouldChange = textShouldChange
    }
    
    
    func bindTextField(textField: UITextField, shouldClear: TextFieldShouldClearFunction?) {
        let binder = self.getBinderForTextField(textField)
        binder.shouldClear = shouldClear
    }
    
    
    func bindTextField(textField: UITextField, shouldReturn: TextFieldShouldReturnFunction?) {
        let binder = self.getBinderForTextField(textField)
        binder.shouldReturn = shouldReturn
    }
    
    func unbind(textField: UITextField) {
        textField.delegate = nil
        binds.removeValueForKey(textField)
    }
    
    func unbindResc(view: UIView) {
        if let tf = (view as? UITextField) {
            self.unbind(tf)
        }
        
        for subView in view.subviews {
            self.unbindResc(subView)
        }
    }
    
    func unbindTextFieldShouldBeginEditing(textField: UITextField) {
        textField.delegate = nil
        if let binder = self.binds[textField] {
            binder.shouldBeginEditing = nil
            if (binder.isEmpty) {
                self.binds.removeValueForKey(textField)
            }
        }
    }
    
    
    func unbindTextFieldDidBeginEditing(textField: UITextField) {
        textField.delegate = nil
        if let binder = self.binds[textField] {
            binder.didBeginEditing = nil
            if (binder.isEmpty) {
                self.binds.removeValueForKey(textField)
            }
        }
    }
    
    
    func unbindTextFieldShouldEndEditing(textField: UITextField) {
        textField.delegate = nil
        if let binder = self.binds[textField] {
            binder.shouldEndEditing = nil
            if (binder.isEmpty) {
                self.binds.removeValueForKey(textField)
            }
        }
    }
    
    
    func unbindTextFielDdidEndEditing(textField: UITextField) {
        textField.delegate = nil
        if let binder = self.binds[textField] {
            binder.didEndEditing = nil
            if (binder.isEmpty) {
                self.binds.removeValueForKey(textField)
            }
        }
    }
    
    
    func unbindTextFieldShouldChangeCharacterInRange(textField: UITextField) {
        textField.delegate = nil
        if let binder = self.binds[textField] {
            binder.shouldChangeCharacterInRange = nil
            if (binder.isEmpty) {
                self.binds.removeValueForKey(textField)
            }
        }
    }
    
    
    func unbindTextFieldTextShouldChange(textField: UITextField) {
        textField.delegate = nil
        if let binder = self.binds[textField] {
            binder.textShouldChange = nil
            if (binder.isEmpty) {
                self.binds.removeValueForKey(textField)
            }
        }
    }
    
    
    func unbindTextFieldShouldClear(textField: UITextField) {
        textField.delegate = nil
        if let binder = self.binds[textField] {
            binder.shouldClear = nil
            if (binder.isEmpty) {
                self.binds.removeValueForKey(textField)
            }
        }
    }
    
    
    func unbindTextFieldShouldReturn(textField: UITextField) {
        textField.delegate = nil
        if let binder = self.binds[textField] {
            binder.shouldReturn = nil
            if (binder.isEmpty) {
                self.binds.removeValueForKey(textField)
            }
        }
    }
    
    deinit {
        for textField in binds {
            textField.0.delegate = nil
        }
    }
}

extension TextBinder: UITextFieldDelegate {
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if let binder = self.binds[textField] {
            if let _func = binder.shouldBeginEditing {
                return _func(textField: textField)
            }
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if let binder = self.binds[textField] {
            if let _func = binder.didBeginEditing {
                _func(textField: textField)
            }
        }
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        if let binder = self.binds[textField] {
            if let _func = binder.shouldEndEditing {
                return _func(textField: textField)
            }
        }
        
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if let binder = self.binds[textField] {
            if let _func = binder.didEndEditing {
                _func(textField: textField)
            }
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var ret = true
        if let binder = self.binds[textField] {
            if let _func = binder.shouldChangeCharacterInRange {
                ret = _func(textField: textField, range: range, replaceString: string)
            }
            
            if let _func = binder.textShouldChange {
                if let rng = textField.text?.rangeFromNSRange(range) {
                    let str = textField.text?.stringByReplacingCharactersInRange(rng, withString: string)
                    ret = _func(textField: textField, text: str)
                }
            }
        }
        
        return ret
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        if let binder = self.binds[textField] {
            if let _func = binder.shouldClear {
                return _func(textField: textField)
            }
        }
        
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let binder = self.binds[textField] {
            if let _func = binder.shouldReturn {
                return _func(textField: textField)
            }
        }
        
        return true
    }
}

extension TextBinder {
    @nonobjc static let DisableKeyboard: TextFieldShouldBeginEditingFunction = {_ in false}
    @nonobjc static let DismissKeyboardOnReturn: TextFieldShouldReturnFunction = {tf in tf.resignFirstResponder() }
}
