//
//  AppointmentAPI.swift
//  DoctorApp
//
//  Created by Salm on 5/2/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit
extension API {
    class func getAppointment(appointmentIds: Int..., success: APIGenericHandler<Appointment>.Arr, failure: APIHandler.Failure?) {
        if appointmentIds.isEmpty {
            success(arr: [])
        }
        
        let query = appointmentIds.map({String($0)}).joinWithSeparator(",")
        self.baseAPI(.GET, path: "/appoinments/\(query)", body: nil,
                     success: APIHandler.toSuccess(genericHandler: success),
                     failure: failure)
    }
    
    class func approveAppointment(appointmentId: Int, result: APIHandler.Result?) {
        self.baseAPI(.PUT, path: "/appointments/\(appointmentId)/approve", body: nil,
                     success: APIHandler.toSuccess(result),
                     failure: APIHandler.toFailure(result))
    }
    
    class func rejectAppointment(appointmentId: Int, result: APIHandler.Result?) {
        self.baseAPI(.PUT, path: "/appointments/\(appointmentId)/reject", body: nil,
                     success: APIHandler.toSuccess(result),
                     failure: APIHandler.toFailure(result))
    }
    
    class func cancelAppointment(appointmentId: Int, result: APIHandler.Result?) {
        self.baseAPI(.PUT, path: "/appointments/\(appointmentId)/cancel", body: nil,
                     success: APIHandler.toSuccess(result),
                     failure: APIHandler.toFailure(result))
    }
    
    class func startAppointment(appointmentId: Int, result: APIHandler.Result?) {
        self.baseAPI(.PUT, path: "/appointments/\(appointmentId)/start", body: nil,
                     success: APIHandler.toSuccess(result),
                     failure: APIHandler.toFailure(result))
    }
}
