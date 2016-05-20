//
//  Timings.swift
//  DoctorApp
//
//  Created by Salm on 4/30/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

class Timings: Object, Mappable {
    dynamic var id: Int = 0
    dynamic var beginTime: Int = 0
    dynamic var length: Int = 0
    dynamic var type: Int = 0
    
    var endTime: Int {
        return beginTime + length
    }
    
    required convenience init?(_ map: Map) {
        self.init()
        
        Utils.validField(Timings.self, map: map)
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(type: Int) {
        self.init()
        self.type = type
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        beginTime <- map["beginTime"]
        length <- map["length"]
        type <- map["type"]
    }
    
    static func addNew(timing: Timings) -> Timings{
        let timing = Timings()
        timing.id = Utils.getIdByTimes()
        RealmHelper.sharedInstance.db_createObject(timing)
        return timing
    }
    
    func editTimeFrom(beginTime: Int){
        RealmHelper.sharedInstance.db_updateObject {
            self.beginTime = beginTime
        }
    }
    
    func lengthTime(length: Int){
        RealmHelper.sharedInstance.db_updateObject {
            self.length = length
        }
    }

}