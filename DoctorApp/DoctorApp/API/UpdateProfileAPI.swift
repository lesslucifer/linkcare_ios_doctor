//
//  UpdateProfileAPI.swift
//  PatientApp
//
//  Created by Salm on 7/4/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit
import ObjectMapper

class UpdateProfileAPI: AnyObject {
    class func changePassword(oldPassword: String, newPassword: String, result: APIHandler.Result?) {
        let body: APIData = [
            "old_password": oldPassword,
            "new_password": newPassword
        ]
        
        API.api2.baseAPI(.PUT, path: "/users/me/password", body: body,
                         success: APIHandler.toSuccess(result),
                         failure: APIHandler.toFailure(result))
    }
    
    class func updateProfile(data: UpdateProfileSubmit, result: APIHandler.Result?) {
        let mapper = Mapper<UpdateProfileSubmit>()
        let body: APIData = APIData(mapper.toJSON(data))
        if (body.isEmpty) {
            result?(success: true, code: 0, msg: "", params: [])
            return
        }
        
        API.api2.baseAPI(.PUT, path: "/users/me", body: body,
                         success: APIHandler.toSuccess(result),
                         failure: APIHandler.toFailure(result))
    }
}
