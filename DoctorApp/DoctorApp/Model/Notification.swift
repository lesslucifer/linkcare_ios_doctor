//
//  Notification.swift
//  DoctorApp
//
//  Created by Julie on 5/6/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit
import ObjectMapper
import SwiftyJSON

class Notification: NSObject, Mappable {
    var id: Int = 0
    var sender: Int?
    var content: String = ""
    var type: NotificationType = .Msg
    var params: [AnyObject]
    var read: Bool = false
    
    private static let ParamsTransformers = TransformOf<[AnyObject], String>(
        fromJSON: {$0 == nil ? nil : JSON.parse($0!).safeArray({$0 as! AnyObject})},
        toJSON: {$0 == nil ? nil : JSON($0!).rawString()})
    
    required init?(_ map: Map) {
        if !Utils.validField(Notification.self, map: map, ignoredFields: ["sender"]) {
            return nil
        }
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        sender <- map["sender"]
        content <- map["content"]
        type <- (map["type"], NotificationType.Transformer)
        params <- (map["params"], Notification.ParamsTransformers)
        read <- map["read"]
    }
}
