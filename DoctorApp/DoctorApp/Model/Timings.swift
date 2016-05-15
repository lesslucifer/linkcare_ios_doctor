//
//  Timings.swift
//  DoctorApp
//
//  Created by Salm on 4/30/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit
import ObjectMapper

class Timings: NSObject, Mappable {
    var beginTime: Int = 0
    var length: Int = 0
    var endTime: Int {
        return beginTime + length
    }
    
    var type: Int = 0
    
    required init?(_ map: Map) {
        Utils.validField(Timings.self, map: map)
    }
    
    func mapping(map: Map) {
        beginTime <- map["beginTime"]
        length <- map["length"]
        type <- map["type"]
    }
}