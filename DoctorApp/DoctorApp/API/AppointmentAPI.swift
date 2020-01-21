//
//  AppointmentAPI.swift
//  DoctorApp
//
//  Created by Salm on 5/2/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit
class AppointmentAPI {
    class func getAppointmentArr(appointmentIds: [Int], success: APIGenericHandler<Appointment>.Arr, failure: APIHandler.Failure?) {
        if appointmentIds.isEmpty {
            success(arr: [])
        }
        
        debugPrint(appointmentIds)
        let query = appointmentIds.map({String($0)}).joinWithSeparator(",")
        API.api1.baseAPI(.GET, path: "/appointments/\(query)", body: nil,
                     success: APIHandler.toSuccess(genericHandler: success),
                     failure: failure)
    }
    
    class func getAppointment(appointmentIds: Int..., success: APIGenericHandler<Appointment>.Arr, failure: APIHandler.Failure?) {
        let arr = appointmentIds.map({$0})
        self.getAppointmentArr(arr, success: success, failure: failure)
    }
    
    class func approveAppointment(appointmentId: Int, result: APIHandler.Result?) {
        API.api1.baseAPI(.PUT, path: "/appointments/\(appointmentId)/approve", body: nil,
                     success: APIHandler.toSuccess(result),
                     failure: APIHandler.toFailure(result))
    }
    
    class func rejectAppointment(appointmentId: Int, result: APIHandler.Result?) {
        API.api1.baseAPI(.PUT, path: "/appointments/\(appointmentId)/reject", body: nil,
                     success: APIHandler.toSuccess(result),
                     failure: APIHandler.toFailure(result))
    }
    
    class func cancelAppointment(appointmentId: Int, reason: String, result: APIHandler.Result?) {
        let body: APIData = [
            "reason": reason
        ]
        API.api1.baseAPI(.PUT, path: "/appointments/\(appointmentId)/cancel", body: body,
                     success: APIHandler.toSuccess(result),
                     failure: APIHandler.toFailure(result))
    }
    
    class func startAppointment(appointmentId: Int, result: APIHandler.Result?) {
        API.api1.baseAPI(.PUT, path: "/appointments/\(appointmentId)/start", body: nil,
                     success: APIHandler.toSuccess(result),
                     failure: APIHandler.toFailure(result))
    }
    
    class func getMedicarAppointments(date: NSDate? = nil, success: APIGenericHandler<CacheModel>.Arr, failure: APIHandler.Failure?) {
        let dateParam = date == nil ? "today" : DateFormat.dateFormatter.stringFromDate(date!)
        API.api1.baseAPI(.GET, path: "/medicar/appointments/\(dateParam)", body: nil,
                     success: APIHandler.toSuccess(genericHandler: success),
                     failure: failure)
    }
    
    class func getMedicarAppointment(status: AppointmentStatus, success: APIGenericHandler<CacheModel>.Arr, failure: APIHandler.Failure?) {
        API.api1.baseAPI(.GET, path: "/medicar/appointments/status/\(status.rawValue)", body: nil,
                     success: APIHandler.toSuccess(genericHandler: success),
                     failure: failure)
    }
    
    class func getMedicarAppointmentByType(type: Int, date: NSDate? = nil, success: APIGenericHandler<AppointmentType>.Single, failure: APIHandler.Failure?) {
        let dateParam = date == nil ? "today" : DateFormat.dateFormatter.stringFromDate(date!)
        API.api1.baseAPI(.GET, path: "/medicar/appointments/\(dateParam)/type/\(type)/count", body: nil,
                    success: APIHandler.toSuccess(genericHandler: success),
                    failure: failure)
    }
    
    
}
