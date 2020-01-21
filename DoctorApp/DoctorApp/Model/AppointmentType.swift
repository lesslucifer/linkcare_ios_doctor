//
//  AppointmentType.swift
//  DoctorApp
//
//  Created by Edward Nguyen on 5/25/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit
import ObjectMapper

class AppointmentType: NSObject, Mappable{
    var count: Int = 0
    
    required init?(_ map: Map) {
        Utils.validField(TimmingSlot.self, map: map)
    }
    
    override required init() {
        
    }
    
    func mapping(map: Map) {
        count <- map["count"]
    }
}