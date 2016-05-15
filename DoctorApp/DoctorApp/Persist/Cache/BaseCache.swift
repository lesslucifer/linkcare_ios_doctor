//
//  BaseCache.swift
//  DoctorApp
//
//  Created by Salm on 5/12/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit
import RealmSwift

protocol Cacheable {
    func lastUpdate() -> Int64?
}

class BaseCache<T: Object where T: Cacheable>: NSObject {
    typealias FactoryFunc = (keys: [Int], fetcher: ([Int: T]) -> Void) -> Void
    
    let persist: Persist
    var factory: FactoryFunc
    var fetching: Set<Int> = []
    
    required init(persist: Persist, factory: FactoryFunc) {
        self.persist = persist
        self.factory = factory
    }
    
    private func isCacheValid(obj: T, cacheModel: CacheModel) -> Bool {
        if let lastUpdate = cacheModel.lastUpdate {
            if let objLastUpdate = obj.lastUpdate() {
                return objLastUpdate >= lastUpdate
            }
            
            return false
        }
        
        return true
    }
    
    func isContains(cacheModel: CacheModel) -> Bool {
        if let obj = persist.realm.objectForPrimaryKey(T.self, key: cacheModel.id) {
            return isCacheValid(obj, cacheModel: cacheModel)
        }
        
        return false
    }
    
    func isContainsId(id: Int) -> Bool {
        return self.isContains(CacheModel(id: id))
    }
    
    func get(cacheModel: CacheModel, fetcher: ((T?) -> ())? = nil) -> T? {
        if let obj = persist.realm.objectForPrimaryKey(T.self, key: cacheModel.id) {
            if isCacheValid(obj, cacheModel: cacheModel) {
                if fetcher != nil {
                    Utils.later({
                        fetcher!(obj)
                    })
                }
                return obj
            }
        }
        
        if fetcher != nil {
            fetching.insert(cacheModel.id)
            self.factory(keys: [cacheModel.id], fetcher: { objs in
                self.fetching.remove(cacheModel.id)
                if let obj = objs[cacheModel.id] {
                    self.persist.write {
                        self.persist.realm.add(obj, update: true)
                    }
                }
                fetcher!(objs[cacheModel.id])
            })
        }
        
        return nil
    }
    
    func get(id: Int, fetcher: ((T?) -> ())? = nil) -> T? {
        return self.get(CacheModel(id: id), fetcher: fetcher)
    }
    
    func fetch(cacheModels: [CacheModel], fetcher: (([Int: T]) -> ())?) {
        var result: [Int: T] = [:]
        var missing: [Int] = []
        
        for cacheModel in cacheModels {
            if let obj = self.get(cacheModel) {
                result[cacheModel.id] = obj
            }
            else {
                missing.append(cacheModel.id)
            }
        }
        
        if missing.isEmpty {
            fetcher?(result)
            return
        }
        
        missing.forEach({self.fetching.insert($0)})
        self.factory(keys: missing, fetcher: { objs in
            var newObjs: [T] = []
            for (id, obj) in objs {
                result[id] = obj
                newObjs.append(obj)
            }
            
            self.persist.write {
                self.persist.realm.add(newObjs, update: true)
            }
            
            missing.forEach({self.fetching.remove($0)})
            fetcher?(result)
        })
    }
    
    func fetch(ids: [Int], fetcher: (([Int: T]) -> ())?) {
        self.fetch(ids.map({CacheModel(id: $0)}), fetcher: fetcher)
    }
    
    func reduceFetchingIds(ids: [Int]) -> [Int] {
        return ids.filter({!self.fetching.contains($0)})
    }
    
    func reduceFetching(ids: [CacheModel]) -> [CacheModel] {
        return ids.filter({!self.fetching.contains($0.id)})
    }
}
