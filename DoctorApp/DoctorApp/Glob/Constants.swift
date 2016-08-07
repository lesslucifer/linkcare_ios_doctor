//
//  Constants.swift
//  MyMediSquare Doctor
//
//  Created by Edward Nguyen on 4/30/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import Foundation
import ObjectMapper

class HOST {
    static let PROD_API1 = "api.concon.vn"
    static let PROD_API2 = "api2.concon.vn"
    static let STAGING_API1 = "staging.api.concon.vn"
    static let STAGING_API2 = "staging.api2.concon.vn"
    
    static let IS_PRODUCTION = false
    
    static var API1: String {
        if (IS_PRODUCTION) {
            return PROD_API1
        }
        
        return STAGING_API1
    }
    static var API2: String {
        if (IS_PRODUCTION) {
            return PROD_API2
        }
        
        return STAGING_API2
    }
}

struct Constants {
    
}

enum RightMenu: Int {
    case Home = 0
    case Profile = 1
    case Appointments = 2
    case Schedule = 3
    case Notification = 5
    case SignOut = 4
}

class HC: NSObject {
    static let ROLE_DOCTOR = 2
    static let ROLE_NURSE = 3
    
    static let TYPE_CLINIC = 0
    static let TYPE_PATIENT_HOME = 1
    
    static let ANIM_DUR_DEFAULT = 0.3
    static let ANIM_DUR_MENU = ANIM_DUR_DEFAULT
    static let DEFAULT_LOCATION: Location = (10.77, 106.69)
    static let REFRESH_TOKEN = "refresh_token"
}

@objc
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

@objc
enum Gender: Int {
    case Male = 0
    case Female = 1
    
    static let Transformer = TransformOf<Gender, Int>(fromJSON: {$0 == nil ? nil : Gender(rawValue: $0!)}, toJSON: {$0?.rawValue})
    func str() -> String {
        if self == .Male {
            return "Nam"
        }
        else {
            return "Nữ"
        }
    }
}

@objc
enum NotificationType: Int {
    case Msg = 0
    case AppointmentBooking = 1
    case AppointmentApproved = 2
    case AppointmentRejected = 3
    case AppointmentCancelled = 4
    case AppointmentFinished =  5
    
    static let Transformer = TransformOf<NotificationType, Int>(fromJSON: {$0 == nil ? nil : NotificationType(rawValue: $0!)}, toJSON: {$0?.rawValue})
}

@objc
enum PositionType: Int {
    case Clinic = 0
    case PatientHome = 1
    
    static let TransformerInt = TransformOf<PositionType, Int>(fromJSON: {$0 == nil ? nil : PositionType(rawValue: $0!)}, toJSON: {$0?.rawValue})
    static let TransformerBool = TransformOf<PositionType, Bool>(fromJSON: {($0 == nil || !$0!) ? PositionType.Clinic : PositionType.PatientHome}, toJSON: {$0 == .PatientHome})
    
    func str() -> String {
        if self == .Clinic {
            return "Phòng Khám"
        }
        else {
            return "Nhà Bệnh Nhân"
        }
    }
}

struct Color {
    static let AppColor = Utils.UIColorFromRGB(red: 85, green: 161, blue: 192)
    static let DeepBlue = Utils.UIColorFromRGB(red: 10, green: 71, blue: 118)
    static let SkyBlue = Utils.UIColorFromRGB(red: 0, green: 173, blue: 239)
}

typealias Location = (latitude: Double, longitude: Double)

@objc
enum GraduatedType: Int {
    case Vocational = 0
    case College = 1
    case Universe = 2
}

@objc
enum MasterType: Int {
    case Master = 0
    case Specialist1 = 1
    case Doctor = 2
    case Specialist2 = 3
}

