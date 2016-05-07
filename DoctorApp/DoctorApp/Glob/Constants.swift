//
//  Constants.swift
//  MyMediSquare Doctor
//
//  Created by Edward Nguyen on 4/30/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import Foundation

struct Constants {
    
}

enum RightMenu {
    case Home
    case Appointments
    case Schedule
    case SignOut
}

struct DateFormat {
    static let dateTimeFormatFull = "dd MMMM yyyy          h : mm a"
    
    static var dateTimeFullFormatter: NSDateFormatter {
        struct Static {
            static var instance : NSDateFormatter? = nil
            static var token : dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = NSDateFormatter()
            Static.instance?.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            Static.instance?.dateFormat = DateFormat.dateTimeFormatFull
        }
        
        return Static.instance!
    }
    

    
}

struct MMColor {
    static let DeepBlue = Utils.UIColorFromRGB(red: 10, green: 71, blue: 118)
    static let SkyBlue = Utils.UIColorFromRGB(red: 0, green: 173, blue: 239)
    static let Cloud = Utils.UIColorFromRGB(red: 224, green: 224, blue: 224)
    static let DarkGray = Utils.UIColorFromRGB(red: 149, green: 149, blue: 149)
    static let orange = Utils.UIColorFromRGB(red: 243, green: 101, blue: 35)
    static let LightBlue = Utils.UIColorFromRGB(red: 182, green: 235, blue: 254)
    static let LightOrange = Utils.UIColorFromRGB(red: 255, green: 218, blue: 201)
    static let redDelete = Utils.UIColorFromRGB(red: 237, green: 28, blue: 36)
}

