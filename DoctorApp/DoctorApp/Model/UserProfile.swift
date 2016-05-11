//
//  UserProfile.swift
//  DoctorApp
//
//  Created by Julie on 5/6/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

class UserProfile: Object, Mappable {
    
    dynamic var id = 0
    dynamic var fullName = ""
    dynamic var age = 0
    dynamic var yearOfBirth = 0
    dynamic var idCard = ""
    dynamic var sex: Gender = .Male
    dynamic var address = ""
    
    required convenience init?(_ map: Map) {
        self.init()
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
