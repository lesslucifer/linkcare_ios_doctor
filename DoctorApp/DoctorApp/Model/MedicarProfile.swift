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
    
    var masterYear: Int?
    var masterSpec: String?
    
    var doctorYear: Int?
    var doctorSpec: String?
    
    var specialist1Year: Int?
    var specialist1Spec: String?
    
    var specialist2Year: Int?
    var specialist2Spec: String?
    
    var otherSpecialistYear: Int?
    var otherSpecialistSpec: String?
    
    var otherTraining: String?
    
    var level: Int?
    var clinicPrice: Int = 0
    var patientHomePrice: Int = 0
    
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
        
        masterYear <- map["masterYear"]
        masterSpec <- map["masterSpec"]
        
        doctorYear <- map["doctorYear"]
        doctorSpec <- map["doctorSpec"]
        
        specialist1Year <- map["specialist1Year"]
        specialist1Spec <- map["specialist1Spec"]
        
        specialist2Year <- map["specialist2Year"]
        specialist2Spec <- map["specialist2Spec"]
        
        otherSpecialistYear <- map["otherSpecialistYear"]
        otherSpecialistSpec <- map["otherSpecialistSpec"]
        
        otherTraining <- map["otherTraining"]
        
        level <- map["level"]
        clinicPrice <- map["clinicPrice"]
        patientHomePrice <- map["patientHomePrice"]
    }
}
