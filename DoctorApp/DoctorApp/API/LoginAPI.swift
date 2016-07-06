//
//  LoginAPI.swift
//  DoctorApp
//
//  Created by Salm on 4/28/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit

class LoginAPI {
//    class func login(idcard: String, password: String, success: APIGenericHandler<LoginResp>.Single, failure: APIHandler.Failure? = nil) {
//        let body: APIData = ["loginName": idcard, "password": password]
//        API.api1.baseAPI(.POST, path: "/account/login", body: body,
//                    success: APIHandler.toSuccess(genericHandler: success), failure: failure)
//    }
    
    class func logout(success: APIHandler.Success? = nil, failure: APIHandler.Failure? = nil) {
        if Utils.isEmpty(API.api1.auth.session) {
            success?(data: [:])
            return
        }
        
        API.api1.baseAPI(.PUT, path: "/account/logout", body: nil, success: success, failure: failure)
    }
    
    class func login2(idcard: String, password: String, success: APIGenericHandler<Login2Resp>.Single, failure: APIHandler.Failure? = nil) {
        var body: APIData = ["loginName": idcard, "password": password, "app": "LINKCAREP"]
        if let deviceToken = Glob.deviceToken {
            body["device"] = [
                "token": deviceToken,
                "type": "APNS"
            ]
        }
        API.api2.baseAPI(.POST, path: "/login", body: body,
                         success: APIHandler.toSuccess(genericHandler: success), failure: failure)
    }
    
    class func getAccessToken(refreshToken: String, success: APIGenericHandler<GetAccessTokenResp>.Single, failure: APIHandler.Failure? = nil) {
        let query = "/token?refresh_token=\(refreshToken)"
        API.api2.baseAPI(.GET, path: query, body: nil, success: APIHandler.toSuccess(genericHandler: success), failure: failure)
    }
}