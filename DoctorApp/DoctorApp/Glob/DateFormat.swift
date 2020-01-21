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
    static let dateTimeFormatFull = "dd MMMM yyyy          h : mm a"
    static let dateFormat = "dd-MM-yyyy"
    static let dateTimeFormat = "dd-MM-yyyy hh:mm"
    static let dateTimeMsecFormat = "dd-MM-yyyy hh:mm:ss.SSS"
    static let shortTimeFormat = "hh:mm aa"
    static let dateDotFormat = "dd.MM.yyyy"
    static let yearFormat = "yyyy"
    
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
    
    static let dateTimeMsecFormatter = Utils.createFormatter(dateTimeMsecFormat)
    static let dateTimeMsecTransformer = Utils.createDateTransformer(dateTimeMsecFormatter)
    
    
    static let shortTimeFormatter = Utils.createFormatter(shortTimeFormat)
    static let shortTimeTransformer = Utils.createDateTransformer(shortTimeFormatter)
    
    
    static let dateDotFormatter = Utils.createFormatter(dateDotFormat)
    static let dateDotTransformer = Utils.createDateTransformer(dateDotFormatter)
    
    
    static let yearFormatter = Utils.createFormatter(yearFormat)
    static let yearTransformer = Utils.createDateTransformer(yearFormatter)
    
    
    static func formatMinuteTime(minute: Int, separator: String = ":") -> String {
        let h = minute / 60
        let m = minute % 60
        
        return "\(String(format: "%02d", h))\(separator)\(String(format: "%02d", m))"
    }
    
    static func weekDayName(weekDay: Int) -> String {
        switch weekDay {
        case 1:
            return "Chủ Nhật"
        case 2:
            return "Thứ 2"
        case 3:
            return "Thứ 3"
        case 4:
            return "Thứ 4"
        case 5:
            return "Thứ 5"
        case 6:
            return "Thứ 6"
        case 7:
            return "Thứ 7"
        default:
            return ""
        }
    }
}
