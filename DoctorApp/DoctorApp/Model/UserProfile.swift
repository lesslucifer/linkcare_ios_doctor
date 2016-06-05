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
    dynamic var birthDay = NSDate()
    dynamic var idCard = ""
    dynamic var sex: Gender = .Male
    dynamic var address = ""
    dynamic var phoneNumber = ""
    dynamic var longtitude = 0.0
    dynamic var latitude = 0.0
    
    required convenience init?(_ map: Map) {
        self.init()
        if !Utils.validField(UserProfile.self, map: map) {
            return nil
        }
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        fullName <- map["fullName"]
        birthDay <- (map["birthDay"], DateFormat.dateTransformer)
        sex <- (map["sex"], Gender.Transformer)
        address <- map["address"]
        phoneNumber <- map["phoneNumber"]
        longtitude <- map["longtitude"]
        latitude <- map["latitude"]
    }
}
