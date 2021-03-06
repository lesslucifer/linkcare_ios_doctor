//
//  NotificationAPI.swift
//  DoctorApp
//
//  Created by Julie on 5/6/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit

class NotificationAPI {
    class func getNotifications(success: APIGenericHandler<Int>.Arr, failure: APIHandler.Failure?) {
        API.api1.baseAPI(.GET, path: "/notifications", body: nil,
                    success: { data in
                        let arr = data.safeArray({$0.int}).filter({$0 != nil}).map({$0!})
                        success(arr: arr)
            }, failure: failure)
    }
    
    class func getNotifications(ids: [Int], success: APIGenericHandler<Notification>.Arr, failure: APIHandler.Failure?) {
        if ids.isEmpty {
            success(arr: [])
            return
        }
        
        let query = ids.map({String($0)}).joinWithSeparator(",")
        API.api1.baseAPI(.GET, path: "/notifications/\(query)", body: nil,
                    success: APIHandler.toSuccess(genericHandler: success), failure: failure)
    }
    
    class func setNotificationRead(ids: [Int], result: APIHandler.Result?) {
        if ids.isEmpty {
            APIHandler.toSuccess(result)?(data: [:])
        }
        
        let query = ids.map({String($0)}).joinWithSeparator(",")
        API.api1.baseAPI(.PUT, path: "/notifications/\(query)/read", body: nil,
                    success: APIHandler.toSuccess(result),
                    failure: APIHandler.toFailure(result))
    }
}
