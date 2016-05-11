//
//  Profile.swift
//  DoctorApp
//
//  Created by Julie on 5/6/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit
import ObjectMapper

class ProfileAPI: NSObject {
    class func getUserProfile(success: APIGenericHandler<UserProfile>.Single, failure: APIHandler.Failure?) {
        API.baseAPI(.GET, path: "/account/profile", body: nil,
                    success: APIHandler.toSuccess(genericHandler: success),
                    failure: failure)
    }
    
    class func getMedicarProfile(accountId: Int?, success: APIGenericHandler<MedicarProfile>.Single, failure: APIHandler.Failure?) {
        let accId = accountId == nil ? "me" : String(accountId)
        
        API.baseAPI(.GET, path: "/account/\(accId)/medicar_profile", body:nil,
                    success: APIHandler.toSuccess(genericHandler: success),
                    failure: failure)
    }
}
