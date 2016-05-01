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