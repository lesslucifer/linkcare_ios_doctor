//
//  TimingsAPI.swift
//  DoctorApp
//
//  Created by Salm on 4/30/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit
import ObjectMapper

class TimingsAPI {
    class func getTimings(success: APIGenericHandler<Timings>.Arr, failure: APIHandler.Failure?) {
        return API.api1.baseAPI(.GET, path: "/timings", body: nil,
                            success: APIHandler.toSuccess("timings", genericHandler: success),
                            failure: failure)
    }
    
    class func setTimings(timings: [Timings], finish: APIHandler.Result?) {
        let mapper = Mapper<Timings>()
        let timingsJSON = mapper.toJSONArray(timings)
        let body: APIData = ["timings": timingsJSON]
        
        return API.api1.baseAPI(.POST, path: "/timings", body: body,
                            success: APIHandler.toSuccess(finish),
                            failure: APIHandler.toFailure(finish))
    }
}

class TimingSlotAPI {
    class func getMedicarTimingSlot(date: NSDate? = nil, success: APIGenericHandler<TimmingSlot>.Arr, failure: APIHandler.Failure?) {
        let dateParam = date == nil ? "today" : DateFormat.dateFormatter.stringFromDate(date!)
        return API.api1.baseAPI(.GET, path: "medicar/timings/slot/?date=\(dateParam)", body: nil,
                           success: APIHandler.toSuccess("slots", genericHandler: success),
                           failure: failure)
    }
}




