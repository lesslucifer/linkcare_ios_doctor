//
//  Appointment.swift
//  DoctorApp
//
//  Created by Salm on 5/2/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit
import ObjectMapper

class Appointment: NSObject, Mappable {
    var id: Int = 0
    var lastUpdated: Int64 = 0
    // booker?
    // medicar?
    // address?
    var date: NSDate = NSDate()
    var time: Int = 0
    var duration: Int = 0
    var status: AppointmentStatus = .Waiting
    var patient: AppointmentPatient!
    
    required init?(_ map: Map) {
        if !Utils.validField(Appointment.self, map: map) {
            return nil
        }
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        lastUpdated <- map["lastUpdated"]
        date <- (map["date"], DateFormat.dateTransformer)
        time <- map["time"]
        duration <- map["duration"]
        status <- (map["status"], AppointmentStatus.Transformer)
        patient <- map["patient"]
    }
}

class AppointmentPatient: NSObject, Mappable {
    var name: String = ""
    var birth: NSDate = NSDate()
    var gender: Gender = .Male
    var phone: String = ""
    var symtoms: String = ""
    
    required init?(_ map: Map) {
        if !Utils.validField(AppointmentPatient.self, map: map) {
            return nil
        }
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        birth <- (map["birth"], DateFormat.dateTransformer)
        gender <- (map["gender"], Gender.Transformer)
        phone <- map["phone"]
        symtoms <- map["symtoms"]
    }
}
