//
//  BaseJSONModel.swift
//  DoctorApp
//
//  Created by Salm on 4/30/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit
import ObjectMapper

protocol JSONModel {
    func load(data: APIData)
    func serialize() -> APIData
}

class BaseJSONModel: NSObject, JSONModel, Mappable {
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        
    }
    
    func load(data: APIData) {
    }
    
    func serialize() -> APIData {
        return [:]
    }
}
