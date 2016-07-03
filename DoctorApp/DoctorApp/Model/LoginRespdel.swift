//
//  LoginModel.swift
//  DoctorApp
//
//  Created by Salm on 7/2/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit
import ObjectMapper

class LoginResp: AnyObject, Mappable {
    var session: String = ""
    var roles: [Role] = []
    
    required init?(_ map: Map) {
        if (!Utils.validField(LoginResp.self, map: map)) {
            return nil
        }
    }
    
    func mapping(map: Map) {
        session <- map["session"]
        roles <- map["roles"]
    }
}

class Role: AnyObject, Mappable {
    var code: String = ""
    
    required init?(_ map: Map) {
        if (!Utils.validField(Role.self, map: map)) {
            return nil
        }
    }
    
    func mapping(map: Map) {
        code <- map["code"]
    }
}