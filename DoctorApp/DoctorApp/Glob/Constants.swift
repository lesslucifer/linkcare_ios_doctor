//
//  Constants.swift
//  MyMediSquare Doctor
//
//  Created by Edward Nguyen on 4/30/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import Foundation
import ObjectMapper

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
    static let dateFormat = "dd-MM-yyyy"
    static let dateTimeFormat = "dd-MM-yyyy hh:mm"
    
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
}

class HC: NSObject {
    static let ROLE_DOCTOR = 2
    static let ROLE_NURSE = 3
    
    static let TYPE_CLINIC = 0
    static let TYPE_PATIENT_HOME = 1
}

enum AppointmentStatus: Int {
    case Waiting = 0
    case Approved = 1
    case Rejected = 2
    case Processing = 3
    case Cancelled = 4
    case Finished = 5
    case Rated = 6
    
    static let Transformer = TransformOf<AppointmentStatus, Int>(fromJSON: {$0 == nil ? nil : AppointmentStatus(rawValue: $0!)}, toJSON: {$0?.rawValue})
}

enum Gender: Int {
    case Male = 0
    case Female = 1
    
    static let Transformer = TransformOf<Gender, Int>(fromJSON: {$0 == nil ? nil : Gender(rawValue: $0!)}, toJSON: {$0?.rawValue})
}

enum NotificationType: Int {
    case Msg = 0
    case AppointmentBooking = 1
    case AppointmentApproved = 2
    case AppointmentRejected = 3
    case AppointmentCancelled = 4
    case AppointmentFinished =  5
    
    static let Transformer = TransformOf<NotificationType, Int>(fromJSON: {$0 == nil ? nil : NotificationType(rawValue: $0!)}, toJSON: {$0?.rawValue})
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

