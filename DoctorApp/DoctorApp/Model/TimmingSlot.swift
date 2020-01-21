//
//  TimmingSlot.swift
//  DoctorApp
//
//  Created by Edward Nguyen on 5/25/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit
import ObjectMapper

class TimmingSlot: NSObject, Mappable{
    var time: Int = 0
    var available: Bool = false
    var type: Int = 0
    
    required init?(_ map: Map) {
        Utils.validField(TimmingSlot.self, map: map)
    }
    
    func mapping(map: Map) {
        time <- map["time"]
        available <- map["available"]
        type <- map["type"]
    }
}
