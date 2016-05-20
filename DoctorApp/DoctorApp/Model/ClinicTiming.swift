//
//  ClinicTiming.swift
//  DoctorApp
//
//  Created by Edward Nguyen on 5/18/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class ClinicTiming: Object {
    dynamic var mct_id: String = ""
    dynamic var mct_name: String = ""
    var mct_timings = List<Timings>()
    
    func mct_update(name: String, address: String, listTimings: List<Timings>) {
        RealmHelper.sharedInstance.db_updateObject({
            self.mct_name = name
            self.mct_timings = listTimings
        })
    }
    
    func mct_appendTiming(timing: Timings) {
        RealmHelper.sharedInstance.db_updateObject {
            let idx = self.indexOfTiming(timing)
            if idx >= 0 {
                self.mct_timings.replace(idx, object: timing)
            } else {
                self.mct_timings.append(timing)
            }
        }
    }
    
    func indexOfTiming(timing: Timings) -> Int {
        for (index, cTiming) in self.mct_timings.enumerate() {
            if cTiming.id == timing.id {
                return index
            }
        }
        
        return -1
    }

}
    