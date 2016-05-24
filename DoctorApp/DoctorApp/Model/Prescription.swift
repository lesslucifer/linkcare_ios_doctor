//
//  Prescription.swift
//  DoctorApp
//
//  Created by Salm on 5/5/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit
import ObjectMapper

class Prescription: NSObject, Mappable {
    var appointmentId: Int = 0
    var date: NSDate = NSDate()
    var note: String = ""
    var instruction: String = ""
    var medicines: [PrescriptionMedicine] = []
    
    override required init() {
        
    }
    
    convenience required init?(_ map: Map) {
        self.init()
        
        let ignored: Set<String> = ["note"]
        let required = ["note.text"]
        if !Utils.validField(Prescription.self, map: map, ignoredFields: ignored, required: required) {
            return nil
        }
    }
    
    func mapping(map: Map) {
        appointmentId <- map["appointmentId"]
        date <- (map["date"], DateFormat.dateTransformer)
        note <- map["note.text"]
        instruction <- map["instruction"]
        medicines <- map["medicines"]
    }
}

class PrescriptionMedicine: NSObject, Mappable {
    var name: String = ""
    var quantityTotal: Int = 0
    var quantityMorning: Double = 0
    var quantityNoon: Double = 0
    var quantityAfternoon: Double = 0
    var quantityNight: Double = 0
    var instr: String = ""
    
    override required init() {
        
    }
    
    convenience required init?(_ map: Map) {
        self.init()
        
        if !Utils.validField(PrescriptionMedicine.self, map: map) {
            return nil
        }
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        quantityTotal <- map["quantityTotal"]
        quantityMorning <- map["quantityMorning"]
        quantityNoon <- map["quantityNoon"]
        quantityAfternoon <- map["quantityAfternoon"]
        quantityNight <- map["quantityNight"]
        instr <- map["instr"]
    }
}