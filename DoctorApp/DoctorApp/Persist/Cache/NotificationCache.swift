//
//  NotificationCache.swift
//  DoctorApp
//
//  Created by Edward Nguyen on 5/22/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import Foundation

class NotificationCache: BaseCache<Notification> {
    static let INST = NotificationCache()
    required init() {
        super.init(persist: Persist.INST, factory: { ids, fetcher in
            NotificationAPI.getNotifications(ids, success: { (arr) in
                var objs: [Int: Notification] = [:]
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