//
//  PrescriptionAPI.swift
//  DoctorApp
//
//  Created by Salm on 5/5/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit
import ObjectMapper

class PrescriptionAPI {
    class func submitPrescription(prescription: Prescription, result: APIHandler.Result?) {
        let mapper = Mapper<Prescription>()
        let body = APIData(mapper.toJSON(prescription))
        
        API.baseAPI(.POST, path: "/prescriptions", body: body,
                     success: APIHandler.toSuccess(result),
                     failure: APIHandler.toFailure(result))
    }
    
    class func getPrescriptions(prescriptions: [Int], success: APIGenericHandler<Int>.Arr, failure: APIHandler.Failure?) {
        if (prescriptions.isEmpty) {
            success(arr: [])
            return
        }
        
        let query = prescriptions.map({String($0)}).joinWithSeparator(",")
        let succHandler: APIHandler.Success = { (data: APIData) in
            success(arr: data.safeArray({$0.intValue}))
        }
        
        API.baseAPI(.GET, path: "/prescriptions/\(query)", body: nil, success: succHandler, failure: failure)
    }
}
