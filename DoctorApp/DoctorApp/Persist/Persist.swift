//
//  Persist.swift
//  DoctorApp
//
//  Created by Salm on 5/12/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit
import RealmSwift

class Persist: NSObject {
    static let INST = Persist()
    
    let realm = try! Realm(configuration: Realm.Configuration(
        fileURL: Realm.Configuration.defaultConfiguration.fileURL!
            .URLByDeletingLastPathComponent?.URLByAppendingPathComponent("LinkCare_\(Utils.versionStr).realm"),
        readOnly: false))
//    let realm = try! Realm()
    
    func write(op: ()->()) {
        try! realm.write(op)
    }
    
    //
    //MARK: CRUD functions
    func db_createObject(object: Object) {
        do {
            try realm.write {
                self.realm.add(object)
            }
        } catch {
            print("Error saving")
        }
    }
    
    
    func db_updateObject(updateBlock: (() -> Void)) {
        try! realm.write {
            updateBlock()
        }
    }
    
    func db_updateWithRealm(updateBlock: ((realm: Realm) -> Void)) {
        try! realm.write {
            updateBlock(realm: self.realm)
        }
    }
    
    func db_deleteObject(object: Object) {
        try! realm.write {
            self.realm.delete(object)
        }
    }
    
    func db_deleteObjects<T>(objects: Results<T>) {
        try! realm.write {
            self.realm.delete(objects)
        }
    }
    
    func db_deleteObjects<T: Object>(objects: Array<T>) {
        try! realm.write {
            self.realm.delete(objects)
        }
    }
    
    func db_addObject(object: Object, update: Bool = false) {
        try! realm.write {
            self.realm.add(object, update: update)
        }
    }
    
    func db_addObjects(objects: [Object], update: Bool = false) {
        try! realm.write {
            self.realm.add(objects, update: update)
        }
    }
    
    func db_objects<T: Object>(type: T.Type) -> Results<T> {
        return realm.objects(type)
    }
    
    func db_wipeDBOnSignout() {
        try! realm.write {
            self.realm.deleteAll()
        }
    }
}

extension Persist {
    
    func db_getObjects<T: Object>(type: T.Type, temp: Bool) -> Results<T> {
        var objs = realm.objects(type)
        
        if !temp {
            if let primaryKey = type.primaryKey() {
                let mirror: Mirror!
                mirror = Mirror(reflecting: T())
                if let primaryField = mirror.children.filter({$0.0 == primaryKey}).first?.1 {
                    if primaryField.dynamicType == String.self {
                        objs = objs.filter("not (\(primaryKey) BEGINSWITH 'tempID')")
                    }
                }
            }
        }
        
        return objs
    }
    
    func db_getArrObjects<T: Object>(type: T.Type, temp: Bool = false) -> Array<T> {
        return Array<T>(db_getObjects(type, temp: temp))
    }
    
    func db_syncObject<T: Object>(obj: T) {
        self.db_addObject(obj, update: true)
    }
    
    func db_syncObjects<T: Object>(objs: Array<T>, deleteUnexisted: Bool = false) {
        self.db_addObjects(objs, update: true)
        
        if (deleteUnexisted) {
            let unexisted = realm.objects(T).filter({
                
                !objs.contains($0)
                
            })
            
            if (unexisted.count > 0) {
                try! realm.write {
                    self.realm.delete(unexisted)
                }
            }
        }
    }
    
    func db_syncObjects<T, O: Object>(otype: O.Type, tobjs: Array<T>, transform: ((tobj: T) -> O)) {
        self.db_addObjects(tobjs.map(transform), update: true)
    }
    
}