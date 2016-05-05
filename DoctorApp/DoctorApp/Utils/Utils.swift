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
    
    
    static func createFormatter(formatString: String) -> NSDateFormatter {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        formatter.dateFormat = formatString
        return formatter
    }
    
    static func createDateTransformer(formatter: NSDateFormatter) -> TransformOf<NSDate, String> {
        return TransformOf<NSDate, String>(fromJSON: { s in
            if Utils.isEmpty(s) {
                return nil
            }
            
            return formatter.dateFromString(s!)
            }, toJSON: { d in
                if Utils.isEmpty(d) {
                    return nil
                }
                
                return formatter.stringFromDate(d!)
        })
    }
}
