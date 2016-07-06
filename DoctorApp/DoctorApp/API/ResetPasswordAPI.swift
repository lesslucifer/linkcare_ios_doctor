//
//  ResetPasswordAPI.swift
//  PatientApp
//
//  Created by Salm on 7/3/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit

class ResetPasswordAPI: AnyObject {
    class func sendResetPasswordRequest(idCard: String, result: APIHandler.Result?) {
        let body: APIData = [
            "id_card": idCard
        ]
        API.api2.baseAPI(.POST, path: "/users/reset_password", body: body,
                     success: APIHandler.toSuccess(result),
                     failure: APIHandler.toFailure(result))
    }
}
