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

class UserProfile: AnyObject, Mappable {
    
    dynamic var id = 0
    dynamic var fullName = ""
    dynamic var birthDay = NSDate()
    dynamic var idCard = ""
    dynamic var sex: Gender = .Male
    dynamic var address = ""
    dynamic var phoneNumber = ""
    dynamic var email = ""
    dynamic var longtitude = 0.0
    dynamic var latitude = 0.0
    
    required convenience init?(_ map: Map) {
        self.init()
        if !Utils.validField(UserProfile.self, map: map, ignoredFields: ["email"]) {
            return nil
        }
    }
    
    //    override class func primaryKey() -> String? {
    //        return "id"
    //    }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.fullName <- map["fullName"]
        self.idCard <- map["idCard"]
        self.birthDay <- (map["birthDay"], DateFormat.dateTransformer)
        self.sex <- (map["sex"], Gender.Transformer)
        self.address <- map["address"]
        self.phoneNumber <- map["phoneNumber"]
        self.email <- map["email"]
        self.longtitude <- map["longtitude"]
        self.latitude <- map["latitude"]
    }
}
