//
//  DateFormat.swift
//  DoctorApp
//
//  Created by Salm on 5/11/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit
import Foundation

class DateFormat: NSObject {
    static let dateTimeFormatFull = "h:mm a,dd.MM.yyyy"
    static let dateFormat = "dd-MM-yyyy"
    static let dateTimeFormat = "dd-MM-yyyy hh:mm"
    static let shortTimeFormat = "hh:mm aa"
    static let dateDotFormat = "dd.MM.yyyy"
    
    static var dateTimeFullFormatter: NSDateFormatter {
        struct Static {
            static var instance : NSDateFormatter? = nil
            static var token : dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = Utils.createFormatter(DateFormat.dateTimeFormatFull)
        }
        
        return Static.instance!
    }
    
    static let dateFormatter: NSDateFormatter = Utils.createFormatter(dateFormat)
    static let dateTransformer = Utils.createDateTransformer(dateFormatter)
    
    
    static let dateTimeFormatter = Utils.createFormatter(dateTimeFormat)
    static let dateTimeTransformer = Utils.createDateTransformer(dateTimeFormatter)
    
    
    static let shortTimeFormatter = Utils.createFormatter(shortTimeFormat)
    static let shortTimeTransformer = Utils.createDateTransformer(shortTimeFormatter)
    
    
    static let dateDotFormatter = Utils.createFormatter(dateDotFormat)
    static let dateDotTransformer = Utils.createDateTransformer(dateDotFormatter)
    
    static func formatMinuteTime(minute: Int) -> String {
        let h = minute / 60
        let m = minute % 60
        
        return "\(String(format: "%02d", h)).\(String(format: "%02d", m))"
    }
}
