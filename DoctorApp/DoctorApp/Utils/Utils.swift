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
    
    class func validField(clazz: AnyClass, map: Map, ignoredFields: Set<String> = [], required: [String] = []) -> Bool {
        let properties = NSObject.propertyNames(clazz)
        for property in properties {
            if ignoredFields.contains(property) {
                continue
            }
            
            if map.JSONDictionary[property] == nil {
                return false
            }
        }
        
        for reqField in required {
            if map.JSONDictionary[reqField] == nil {
                return false
            }
        }
        
        return true
    }
    
    class func checkMap(map: Map, fields: String...) -> Bool {
        for field in fields {
            if map[field].value() == nil {
                return false
            }
        }
        
        return true
    }
    
    func randomString(len : Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for _ in 0..<len {
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString as String
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
    
    class func later(block: dispatch_block_t) {
        dispatch_async(dispatch_get_main_queue(), block)
    }
    
    class func converTimetoHour(time: Int) -> Int {
        return (time - time%60) / 60
    }
    
    class func converTimetoMinute(time: Int) -> String {
        let minute = time%60
        if minute < 10 {
            return "0\(minute)"
        } else {
            return "\(minute)"
        }
    }
    
    class func converTimetoString(time: Int) -> String {
        return "\(converTimetoHour(time)):\(converTimetoMinute(time))"
    }
    
    class func converStringTimeToInt(stringTime: String) -> Int {
        let timeArr = stringTime.characters.split{$0 == ":"}.map(String.init)
        let hours = Int(timeArr[0])
        let minute = Int(timeArr[1])
        let intTime = hours! * 60 + minute!
        
        return intTime
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
    
    class func showOKAlertPanel(controller: UIViewController, title: String, msg: String, callback: ((UIAlertAction)->())? = nil) {
        let alert = UIAlertController(title:title, message: msg, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: callback))
        
        controller.presentViewController(alert, animated: true, completion: nil)
    }
}

//MARK: Date time helper
extension Utils {
    class func getNowTimestamp() -> Double {
        let currentDateTime = NSDate()
        
        return currentDateTime.timeIntervalSince1970
    }
    
    class func getIdByTimes() -> Int {
        let currentDateTime = NSDate()
        
        return Int(currentDateTime.timeIntervalSince1970)
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
    
    class func age(date: NSDate) -> Int {
        let now = NSDate()
        let calendar = NSCalendar.currentCalendar()
        
        return calendar.components(.Year,
                                   fromDate: date,
                                   toDate: now,
                                   options: []).year
    }
}

extension String {
    var emptyCheck: String? {
        if Utils.isEmpty(self) {
            return nil
        }
        
        return self
    }
}
