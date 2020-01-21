//
//  VersionAPI.swift
//  PatientApp
//
//  Created by Salm on 7/5/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit

class VersionAPI: AnyObject {
    class func checkVersion(result: APIHandler.Result?) {
        let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as! String
        let build = NSBundle.mainBundle().infoDictionary?[kCFBundleVersionKey as String] as! String
        let versionStr = "\(version).\(build)"
        let body: APIData = [
            "version": versionStr,
            "app": "LINKCAREP",
            "device": "IOS"
        ]
        API.api2.baseAPI(.POST, path: "/version", body: body,
                         success: APIHandler.toSuccess(result),
                         failure: APIHandler.toFailure(result))
    }
}
