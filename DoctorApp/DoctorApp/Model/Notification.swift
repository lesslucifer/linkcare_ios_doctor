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
import RealmSwift

class Notification: Object, Mappable, Cacheable {
    dynamic var id: Int = 0
    dynamic var sender: Int = 0
    dynamic var content: String = ""
    dynamic var type: NotificationType = .Msg
//    var params: [AnyObject]?
    dynamic var read: Bool = false
    
//    private static let ParamsTransformers = TransformOf<[AnyObject], String>(
//        fromJSON: {$0 == nil ? nil : JSON.parse($0!).safeArray({$0 as! AnyObject})},
//        toJSON: {$0 == nil ? nil : JSON($0!).rawString()})
    
    convenience required init?(_ map: Map) {
        self.init()
        
        if !Utils.validField(Notification.self, map: map, ignoredFields: ["sender"]) {
            return nil
        }
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    func mapping(map: Map) {
        self.write {
            if self.id == 0 {
                self.id <- map["id"]
            }
            self.sender <- map["sender"]
            self.content <- map["content"]
            self.type <- (map["type"], NotificationType.Transformer)
            //        self.params <- (map["params"], Notification.ParamsTransformers)
            self.read <- map["read"]
        }
    }
    
    func lastUpdate() -> Int64? {
        return 0
    }
}
