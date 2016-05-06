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
        return API.baseAPI(.GET, path: "/timings", body: nil,
                            success: APIHandler.toSuccess("timings", genericHandler: success),
                            failure: failure)
    }
    
    class func setTimings(timings: [Timings], finish: APIHandler.Result?) {
        let mapper = Mapper<Timings>()
        let timingsJSON = mapper.toJSONArray(timings)
        let body: APIData = ["timings": timingsJSON]
        
        return API.baseAPI(.POST, path: "/timings", body: body,
                            success: APIHandler.toSuccess(finish),
                            failure: APIHandler.toFailure(finish))
    }
}
