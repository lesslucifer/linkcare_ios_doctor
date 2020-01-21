//
//  UpdateProfileSubmit.swift
//  PatientApp
//
//  Created by Salm on 7/4/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit
import ObjectMapper

class UpdateProfileSubmit: AnyObject, Mappable {
    var firstName: String?
    var lastName: String?
    var midleName: String?
    var gender: Gender?
    var birthday: NSDate?
    var email: String?
    var phoneNumber: String?
    var address: Address?
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    required init() {
        
    }
    
    func mapping(map: Map) {
        if (!Utils.isEmpty(firstName)) {
            firstName <- map["first_name"]
        }
        
        if (!Utils.isEmpty(lastName)) {
            lastName <- map["last_name"]
        }
        
        if (!Utils.isEmpty(midleName)) {
            midleName <- map["midle_name"]
        }
        
        if (gender != nil) {
            gender <- (map["gender"], Gender.Transformer)
        }
        
        if (!Utils.isEmpty(birthday)) {
            birthday <- (map["birth_day"], DateFormat.dateTransformer)
        }
        
        if (!Utils.isEmpty(email)) {
            email <- map["email"]
        }
        
        if (!Utils.isEmpty(phoneNumber)) {
            phoneNumber <- map["phone_number"]
        }
        
        if (!Utils.isEmpty(address )) {
            address <- map["address"]
        }
    }
    
    var fullName: String {
        get {
            return "\(self.lastName) \(self.midleName) \(self.firstName)"
        }
        set {
            let (lastName, midleName, firstName) = newValue.extractNameComps()
            self.lastName = lastName
            self.midleName = midleName
            self.firstName = firstName
        }
    }
    
    class Address: AnyObject, Mappable {
        var address: String = ""
        var longitude: Double = 0
        var latitude: Double = 0
        
        required convenience init?(_ map: Map) {
            self.init()
        }
        
        required init() {
            
        }
        
        func mapping(map: Map) {
            address <- map["address"]
            longitude <- map["longitude"]
            latitude <- map["latitude"]
        }
    }
}
