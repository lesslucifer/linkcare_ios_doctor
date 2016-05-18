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
    
//    let realm = try! Realm(configuration: Realm.Configuration(path: ""))
    let realm = try! Realm()
    
    func write(op: ()->()) {
        try! realm.write(op)
    }
}