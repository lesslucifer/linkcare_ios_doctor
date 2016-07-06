//
//  GetAccessTokenResp.swift
//  PatientApp
//
//  Created by Salm on 7/4/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit
import ObjectMapper

class GetAccessTokenResp: AnyObject, Mappable {
    var token: Token = Token()
    var roles: [Role] = []
    
    required init?(_ map: Map) {
        if (!Utils.validField(Login2Resp.self, map: map)) {
            return nil
        }
    }
    
    func mapping(map: Map) {
        token <- map["token"]
        roles <- map["roles"]
    }
    
    class Token: AnyObject, Mappable {
        var accessToken: String = ""
        var expired: NSDate = NSDate()
        
        required init() {
            
        }
        
        required convenience init?(_ map: Map) {
            self.init()
            
            if (!Utils.validField(Token.self, map: map)) {
                return nil
            }
        }
        
        func mapping(map: Map) {
            accessToken <- map["access_token"]
            expired <- (map["expired"], DateFormat.dateTimeMsecTransformer)
        }
    }
}