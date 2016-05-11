//
//  RealmHelper.swift
//  DoctorApp
//
//  Created by Edward Nguyen on 5/8/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import RealmSwift

class STRealmHelper{
    static let shareInstance = STRealmHelper()
    
    let realm = try! Realm()
    
    
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
