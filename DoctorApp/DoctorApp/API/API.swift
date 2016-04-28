//
//  API.swift
//  DoctorApp
//
//  Created by Salm on 4/27/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

typealias APIData = JSON

public class API: NSObject {
    // define base API method
    public struct Config {
        var schema = "http"
        var host = "localhost"
        var port = 80
        
        lazy var baseUrl: String = {
            var portDesc = (self.port == 80) ? "" : ": \(self.port)"
            return "\(self.schema)://\(self.host)\(portDesc)"
        }()
    }
    
    public static var config = Config();
    
    typealias SuccessHandle = (data: APIData) -> Void
    typealias FailureHandler = (code: Int, msg: String, params: [String])
    
    
    
    class func url(path: String) -> String {
        var _path = path
        if (!path.hasPrefix("/")) {
            _path = "/\(path)"
        }
        
        return "\(self.config.baseUrl)\(_path)"
    }
    
    class func baseAPI(method: String,
                       path: String, body: APIData?, success: SuccessHandle?, failure: FailureHandler?) {
        
    }
    
    class func baseAPI(method: String,
                       path: String, body: APIData?, success: SuccessHandle?) {
        self.baseAPI(method, path: path, body: body, success: success, failure: nil)
    }
    
    class func baseAPI(method: String,
                       path: String, success: SuccessHandle?) {
        self.baseAPI(method, path: path, body: nil, success: success, failure: nil)
    }
}
