//
//  RealmObject+Write.swift
//  DoctorApp
//
//  Created by Salm on 5/21/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit
import RealmSwift

extension Object {
    func write(block: ()->()) {
        if let r = self.realm {
            try! r.write(block)
        }
        else {
            block()
        }
    }
}
