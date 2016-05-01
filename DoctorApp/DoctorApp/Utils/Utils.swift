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
}
