//
//  CacheModel.swift
//  DoctorApp
//
//  Created by Salm on 5/5/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit
import ObjectMapper

class CacheModel: NSObject, Mappable {
    var id: Int = 0
    var lastUpdate: Int64?
    
    override required init() {
        super.init()
    }
    
    required init?(_ map: Map) {
        if !Utils.validField(CacheModel.self, map: map) {
            return nil
        }
    }
    
    convenience init(id: Int, lastUpdate: Int64? = nil) {
        self.init()
        
        self.id = id
        self.lastUpdate = lastUpdate
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        lastUpdate <- map["lastUpdate"]
    }
}
