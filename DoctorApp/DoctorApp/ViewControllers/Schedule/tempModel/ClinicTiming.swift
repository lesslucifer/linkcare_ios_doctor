//
//  BaseMenuViewController.swift
//  DoctorApp
//
//  Created by Edward Nguyen on 4/30/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class ClinicTiming: Object {
    dynamic var mct_id: String = ""
    dynamic var mct_name: String = ""
    dynamic var mct_address: String = ""
    dynamic var mct_displayName: String = ""
    var mct_timings = List<Timing>()
    
    override class func primaryKey() -> String {
        return "mct_id"
    }
    
    convenience init(id: String, name: String, address:String){
        self.init()
        self.mct_id = id
        self.mct_name = name
        self.mct_address = address
    }
    
    convenience init(data: Dictionary<String, AnyObject>) {
        self.init()
        self.mct_id = String(data["id"] as! Int)
        self.mct_name = data["name"] as! String
        self.mct_address = data["address"] as! String
        if (!Utils.isEmpty(data["display_name"])) {self.mct_displayName = data["display_name"] as! String}
    }
    
//    func mct_update(name: String, address: String, listTimings: List<Timing>) {
//        MMRealmHelper.sharedInstance.db_updateObject({
//            self.mct_name = name
//            self.mct_address = address
//            self.mct_timings = listTimings
//        })
//    }
//    
//    func mct_appendTiming(timing: Timing) {
//        MMRealmHelper.sharedInstance.db_updateObject {
//            let idx = self.indexOfTiming(timing)
//            if idx >= 0 {
//                self.mct_timings.replace(idx, object: timing)
//            } else {
//                self.mct_timings.append(timing)
//            }
//        }
//    }
    
//    func indexOfTiming(timing: Timing) -> Int {
//        for (index, cTiming) in self.mct_timings.enumerate() {
//            if cTiming.mt_Id == timing.mt_Id {
//                return index
//            }
//        }
//        
//        return -1
//    }
    
//    func mbv_deleteTiming(timingId: String) {
//        MMRealmHelper.sharedInstance.db_updateObject {
//            self.mct_timings.removeAtIndex()
//        }
//    }
}
