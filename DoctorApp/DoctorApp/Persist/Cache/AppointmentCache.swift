//
//  AppointmentCache.swift
//  DoctorApp
//
//  Created by Salm on 5/13/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit

extension Appointment: Cacheable {
    func lastUpdate() -> Int64? {
        return self.lastUpdated
    }
}

class AppointmentCache: BaseCache<Appointment> {
    static let INST = AppointmentCache()
    
    required init() {
        super.init(persist: Persist.INST, factory: { ids, fetcher in
            AppointmentAPI.getAppointmentArr(ids, success: { (arr) in
                var objs: [Int: Appointment] = [:]
                for app in arr {
                    objs[app.id] = app
                }
                
                fetcher(objs)
                
            }, failure: { _, _, _ in
                fetcher([:])
            })
        })
    }
}
