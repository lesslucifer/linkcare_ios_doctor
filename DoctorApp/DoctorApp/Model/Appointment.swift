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
        self.write {
            if self.id == 0 {
                self.id <- map["id"]
            }
            self.lastUpdated <- map["lastUpdated"]
            self.date <- (map["date"], DateFormat.dateTransformer)
            self.time <- map["time"]
            self.duration <- map["duration"]
            self.status <- (map["status"], AppointmentStatus.Transformer)
            self.patient <- map["patient"]
            self.type <- (map["atHome"], PositionType.TransformerBool)
        }
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
        self.write {
            self.name <- map["name"]
            self.birth <- (map["birth"], DateFormat.dateTransformer)
            self.gender <- (map["gender"], Gender.Transformer)
            self.address <- map["address"]
            self.phone <- map["phone"]
            self.symtoms <- map["symtoms"]
        }
    }
}
