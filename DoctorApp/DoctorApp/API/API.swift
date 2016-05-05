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
import ObjectMapper

typealias APIMethod = Alamofire.Method
typealias APIData = JSON

struct APIHandler {
    typealias Result = (success: Bool, code: Int, msg: String, params: [String]) -> Void
    typealias Success = (data: APIData) -> Void
    typealias Failure = (code: Int, msg: String, params: [String]) -> Void
    
    static func toSuccess(result: Result?) -> Success? {
        if let r = result {
            return { _ in
                r(success: true, code: 0, msg: "", params: [])
            }
        }
        
        return nil
    }
    
    static func toFailure(result: Result?) -> Failure? {
        if let r = result {
            return { c, m, p in
                r(success: false, code: c, msg: m, params: p)
            }
        }
        
        return nil
    }
    
    static func toSuccess<T: Mappable>(keyPath: String = "", genericHandler: APIGenericHandler<T>.Single) -> APIHandler.Success {
        let mapper = Mapper<T>()
        return { (data: APIData) in
            let subData = data.query(keyPath)
            let obj: T? = mapper.map(subData.dictionaryObject)
            genericHandler(obj: obj)
        }
    }
    
    static func toSuccess<T: Mappable>(keyPath: String = "", genericHandler: APIGenericHandler<T>.Arr) -> APIHandler.Success {
        let mapper = Mapper<T>()
        return { (data: APIData) in
            let subData = data.query(keyPath)
            let arr: [T] = mapper.mapArray(subData.arrayObject) ?? []
            genericHandler(arr: arr)
        }
    }
}

struct APIGenericHandler<T> {
    typealias Single = (obj: T?) -> Void
    typealias Arr = (arr: [T]) -> Void
}

public class API: NSObject {
    // define base API method
    public struct Config {
        let schema: String
        let host: String
        let port: Int
        let basePath: String
        
        init(schema: String = "http", host: String = "localhost", basePath: String = "", port: Int = 80) {
            self.schema = schema
            self.host = host
            self.port = port
            self.basePath = basePath
        }
        
        lazy var baseUrl: String = {
            var portDesc = (self.port == 80) ? "" : ":\(self.port)"
            return "\(self.schema)://\(self.host)\(portDesc)\(self.basePath)"
        }()
    }
    
    public struct Auth {
        let session: String
        
        init(sess: String = "") {
            self.session = sess
        }
    }
    
    public static var config = Config()
    public static var auth = Auth()
    
    class func url(path: String) -> String {
        var _path = path
        if (!path.hasPrefix("/")) {
            _path = "/\(path)"
        }
        
        return "\(self.config.baseUrl)\(_path)"
    }
    
    class func headers() -> [String: String]? {
        if (!Utils.isEmpty(auth.session)) {
            return ["sess": auth.session]
        }
        
        return [:]
    }
    
    class func baseAPI(method: APIMethod,
                       path: String, body: APIData?, success: APIHandler.Success?, failure: APIHandler.Failure?) {
        Alamofire.request(method, url(path), parameters: body?.dictionaryObject, encoding: ParameterEncoding.JSON, headers: headers())
            .responseJSON { resp in
                switch resp.result {
                case .Success(let respData):
                    let data = APIData(respData)
                    if let status = data["status"].bool {
                        if status == false {
                            let err = data["error"]
                            let msg = err["msg"].safeString
                            let code = err["code"].safeInt
                            let params = err["params"].safeArray({$0.safeString})
                            failure?(code: code, msg: msg, params: params)
                        }
                        else {
                            success?(data: data["data"])
                        }
                    }
                    break
                case .Failure(let error):
                    failure?(code: error.code, msg: error.localizedDescription, params: [])
                    break
                }
        }
    }
    
    class func baseAPI(method: APIMethod,
                       path: String, body: APIData?, success: APIHandler.Success?) {
        self.baseAPI(method, path: path, body: body, success: success, failure: nil)
    }
    
    class func baseAPI(method: APIMethod,
                       path: String, success: APIHandler.Success?) {
        self.baseAPI(method, path: path, body: nil, success: success, failure: nil)
    }
}
