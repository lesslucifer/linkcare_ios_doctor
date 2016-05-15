//
//  LoginAPI.swift
//  DoctorApp
//
//  Created by Salm on 4/28/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit

class LoginAPI {
    class func login(idcard: String, password: String, success: APIHandler.Success, failure: APIHandler.Failure? = nil) {
        let body: APIData = ["loginName": idcard, "password": password]
        API.baseAPI(.POST, path: "/account/login", body: body, success: success, failure: failure)
    }
    
    class func logout(success: APIHandler.Success, failure: APIHandler.Failure? = nil) {
        if Utils.isEmpty(API.auth.session) {
            success(data: [:])
            return
        }
        
        API.baseAPI(.PUT, path: "/account/logout", body: [:], success: { data in
            API.auth = API.Auth()
            success(data: data)
            }, failure: failure)
    }
}