//
//  TimingsAPI.swift
//  DoctorApp
//
//  Created by Salm on 4/30/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit
import ObjectMapper

extension API {
    class func getTimings(success: APIGenericHandler<Timings>.Arr, failure: APIHandler.Failure?) {
        return self.baseAPI(.GET, path: "/timings", body: nil, success: { (data) in
            
            let mapper = Mapper<Timings>()
            let timings: [Timings] = mapper.mapArray(data["timings"].arrayObject) ?? []
            success(arr: timings)
            
        }, failure: failure)
    }
    
    class func setTimings(timings: [Timings], finish: APIHandler.Result?) {
        let mapper = Mapper<Timings>()
        let timingsJSON = mapper.toJSONArray(timings)
        let body: APIData = ["timings": timingsJSON]
        
        return self.baseAPI(.POST, path: "/timings", body: body,
                            success: APIHandler.toSuccess(finish),
                            failure: APIHandler.toFailure(finish))
    }
}
