//
//  Utils.swift
//  DoctorApp
//
//  Created by Salm on 4/28/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit
import ObjectMapper

class Utils: NSObject {
    class func isEmpty(o: AnyObject?) -> Bool {
        if o == nil {
            return true
        }
        
        if let str = o as? String {
            return str.isEmpty
        }
        
        return false
    }
    
    class func validField(clazz: AnyClass, map: Map, ignoredFields: String...) -> Bool {
        let properties = NSObject.propertyNames(clazz)
        for property in properties {
            if ignoredFields.contains(property) {
                continue
            }
            
            if map[property].value() == nil {
                return false
            }
        }
        
        return true
    }
    
    //MARK: Color
    class func UIColorFromRGB(red red: Int, green:Int, blue:Int) -> UIColor {
        return UIColor(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    //
    class func invokeLater(block: dispatch_block_t) {
        dispatch_async(dispatch_get_main_queue(), block)
    }
}


//MARK: Alert Helper
extension Utils {
    class func showAlertWithError(error: String) {
        let v_alert: UIAlertView = UIAlertView(title: "", message: error, delegate: nil, cancelButtonTitle: "Ok")
        v_alert.show()
    }
    
    class func showAlertWithError(error: String, delegate: UIAlertViewDelegate) {
        let v_alert: UIAlertView = UIAlertView(title: "", message: error, delegate: delegate, cancelButtonTitle: "Yes", otherButtonTitles: "No")
        v_alert.tag = 20000
        v_alert.show()
    }
}

//MARK: Date time helper
extension Utils {
    class func getNowTimestamp() -> Double {
        let currentDateTime = NSDate()
        
        return currentDateTime.timeIntervalSince1970
    }
    
}
