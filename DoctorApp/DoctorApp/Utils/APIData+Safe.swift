//
//  APIData+Safe.swift
//  DoctorApp
//
//  Created by Salm on 4/30/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit

extension APIData {
    var safeString: String {
        return self.safeString()
    }
    
    func safeString(defValue: String = "") -> String {
        if let str = self.string {
            return str
        }
        
        return ""
    }
    
    var safeInt: Int {
        return self.safeInt()
    }
    
    func safeInt(defaultValue: Int = 0) -> Int {
        if let i = self.int {
            return i
        }
        
        return defaultValue
    }
    
    func safeArray<T>(converter: (APIData) -> T) -> [T] {
        if let arr = self.array {
            return arr.map(converter)
        }
        
        return []
    }
    
    func query(keyPath: String) -> APIData {
        if keyPath.isEmpty {
            return self
        }
        
        let keys = keyPath.componentsSeparatedByString(".")
        var data = self
        for key in keys {
            data = data[key]
        }
        
        return data
    }
}

extension APIData {
    var arrayOfDicts: [[String: AnyObject]]? {
        if let arr = self.array {
            return arr.map({$0.dictionaryObject!})
        }
        
        return nil
    }
}