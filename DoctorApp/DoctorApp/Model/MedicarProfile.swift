//
//  MedicarProfile.swift
//  DoctorApp
//
//  Created by Julie on 5/6/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit
import ObjectMapper

class MedicarProfile: NSObject, Mappable {
    var id: Int = 0
    var lastUpdated: Int64?
    
    var licenseNumber: String?
    
    var graduatedSchool: String?
    var graduatedYear: Int?
    var graduatedLevel: GraduatedType?
    
    var masterSchool: String?
    var masterYear: Int?
    var masterType: MasterType?
    
    var workingPlace: String?
    var study: String?
    
    var clinicPrice: Int = 0
    var patientHomePrice: Int = 0
    
    func buildPrefix(title: String, name: String) -> String {
        if let masterType = self.masterType {
            switch masterType {
            case .Master:
                return "ThS. \(title) \(name)"
            case .Doctor:
                return "TS. \(title) \(name)"
            case .Specialist1:
                return "\(title) CK1 \(name)"
            case .Specialist2:
                return "\(title) CK2 \(name)"
            }
        }
        
        return "\(title) \(name)"
    }
    
    required init?(_ map: Map) {
        if !Utils.checkMap(map, fields: "id", "clinicPrice", "patientHomePrice") {
            return nil
        }
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        lastUpdated <- map["lastUpdated"]
        
        licenseNumber <- map["licenseNumber"]
        
        graduatedSchool <- map["graduatedSchool"]
        graduatedYear <- map["graduatedYear"]
        graduatedLevel <- map["graduatedLevel"]
        
        masterYear <- map["masterYear"]
        masterSchool <- map["masterSchool"]
        masterType <- map["masterType"]
        
        workingPlace <- map["workingPlace"]
        study <- map["study"]
        
        clinicPrice <- map["clinicPrice"]
        patientHomePrice <- map["patientHomePrice"]
    }
}
