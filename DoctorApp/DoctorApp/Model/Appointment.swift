//
//  Appointment.swift
//  DoctorApp
//
//  Created by Salm on 5/2/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

class Appointment: Object, Mappable {
    dynamic var id: Int = 0
    dynamic var lastUpdated: Int64 = 0
    // booker?
    // medicar?
    // address?
    dynamic var date: NSDate = NSDate()
    dynamic var time: Int = 0
    dynamic var duration: Int = 0
    dynamic var status: AppointmentStatus = .Waiting
    dynamic var patient: AppointmentPatient?
    dynamic var type: PositionType = .Clinic
    
    required convenience init?(_ map: Map) {
        self.init()
        
        if !Utils.validField(Appointment.self, map: map, ignoredFields: ["type"], required: ["atHome"]) {
            return nil
        }
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        lastUpdated <- map["lastUpdated"]
        date <- (map["date"], DateFormat.dateTransformer)
        time <- map["time"]
        duration <- map["duration"]
        status <- (map["status"], AppointmentStatus.Transformer)
        patient <- map["patient"]
        type <- (map["atHome"], PositionType.TransformerBool)
    }
}

class AppointmentPatient: Object, Mappable {
    dynamic var name: String = ""
    dynamic var birth: NSDate = NSDate()
    dynamic var gender: Gender = .Male
    dynamic var address: String = ""
    dynamic var phone: String = ""
    dynamic var symtoms: String = ""
    
    required convenience init?(_ map: Map) {
        self.init()
        
        if !Utils.validField(AppointmentPatient.self, map: map) {
            return nil
        }
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        birth <- (map["birth"], DateFormat.dateTransformer)
        gender <- (map["gender"], Gender.Transformer)
        address <- map["address"]
        phone <- map["phone"]
        symtoms <- map["symtoms"]
    }
}
