//
//  BlockVacationAPI.swift
//  DoctorApp
//
//  Created by Salm on 5/6/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit

class BlockVacationAPI {
    class func getBlockVacations(from: NSDate, to: NSDate, success: APIGenericHandler<BlockVacation>.Arr, failure: APIHandler.Failure?) {
        let query = "from=\(DateFormat.dateFormatter.stringFromDate(from))&to=\(DateFormat.dateFormatter.stringFromDate(to))"
        API.baseAPI(.GET, path: "/block_vacations?\(query)", body: nil,
                    success: APIHandler.toSuccess(genericHandler: success), failure: failure)
    }
    
    class func getBlockVacation(ids: [Int], success: APIGenericHandler<BlockVacation>.Arr, failure: APIHandler.Failure?) {
        if ids.isEmpty {
            success(arr: [])
            return
        }
        
        let query = ids.map({String($0)}).joinWithSeparator(",")
        API.baseAPI(.GET, path: "/block_vacations/\(query)", body: nil,
                    success: APIHandler.toSuccess(genericHandler: success), failure: failure)
    }
    
    class func addBlockVacation(blockVacation: BlockVacation, result: APIHandler.Result?) {
        API.baseAPI(.POST, path: "/block_vacations", body: nil,
                    success: APIHandler.toSuccess(result),
                    failure: APIHandler.toFailure(result))
    }
    
    class func deleteBlockVacation(id: Int, result: APIHandler.Result?) {
        
        
    }
}
