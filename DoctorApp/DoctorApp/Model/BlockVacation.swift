//
//  BlockVacation.swift
//  DoctorApp
//
//  Created by Salm on 5/6/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit
import ObjectMapper

class BlockVacation: NSObject, Mappable {
    var id: Int?
    var begin: NSDate = NSDate()
    var length: Int = 0
    
    required init?(_ map: Map) {
        if !Utils.validField(BlockVacation.self, map: map) {
            return nil
        }
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        begin <- map["begin"]
        length <- map["length"]
    }
}
