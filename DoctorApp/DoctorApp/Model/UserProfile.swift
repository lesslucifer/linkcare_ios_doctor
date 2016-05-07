//
//  UserProfile.swift
//  DoctorApp
//
//  Created by Julie on 5/6/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit
import ObjectMapper

class UserProfile: NSObject, Mappable {
    
    var id = 0
    var fullName = ""
    var age = 0
    var yearOfBirth = 0
    var idCard = ""
    var sex: Gender = .Male
    var address = ""
    
    required init?(_ map: Map) {
        if !Utils.validField(UserProfile.self, map: map) {
            return nil
        }
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        fullName <- map["fullName"]
        age <- map["age"]
        yearOfBirth <- map["yearOfBirth"]
        sex <- (map["sex"], Gender.Transformer)
        address <- map["address"]
    }
}
