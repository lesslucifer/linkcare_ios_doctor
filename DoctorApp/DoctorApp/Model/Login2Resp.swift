//
//  Login2Resp.swift
//  PatientApp
//
//  Created by Salm on 7/4/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit
import ObjectMapper

class Login2Resp: AnyObject, Mappable {
    var tokens: Tokens = Tokens()
    var roles: [Role] = []
    
    required init?(_ map: Map) {
        if (!Utils.validField(Login2Resp.self, map: map)) {
            return nil
        }
    }
    
    func mapping(map: Map) {
        tokens <- map["tokens"]
        roles <- map["roles"]
    }
    
    class Tokens: AnyObject, Mappable {
        var refreshToken: String = ""
        var accessToken: String = ""
        var expired: NSDate = NSDate()
        
        required init() {
            
        }
        
        required convenience init?(_ map: Map) {
            self.init()
            
            if (!Utils.validField(Tokens.self, map: map)) {
                return nil
            }
        }
        
        func mapping(map: Map) {
            refreshToken <- map["refresh_token"]
            accessToken <- map["access_token"]
            expired <- (map["expired"], DateFormat.dateTimeMsecTransformer)
        }
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