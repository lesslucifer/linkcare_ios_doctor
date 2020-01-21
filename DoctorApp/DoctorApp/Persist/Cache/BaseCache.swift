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
    typealias ForkFunc = ((Int, T?)->Void)?
    
    let persist: Persist
    var factory: FactoryFunc
    var fetching: [Int: [ForkFunc]] = [:]
    
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
            self.furk([cacheModel.id], f: { _, obj in
                fetcher!(obj)
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
        
        let ids = Set<Int>(cacheModels.map({$0.id}))
        
        self.furk(missing, f: { id, obj in
            if obj != nil {
                result[id] = obj!
            }
            
            if result.count >= ids.count {
                fetcher?(result)
            }
        })
    }
    
    func fetch(ids: [Int], fetcher: (([Int: T]) -> ())?) {
        self.fetch(ids.map({CacheModel(id: $0)}), fetcher: fetcher)
    }
    
    private func furk(ids: [Int], f: ForkFunc) {
        var missing: [Int] = []
        for id in ids {
            if var fork = self.fetching[id] where !fork.isEmpty {
                fork.append(f)
                self.fetching[id] = fork
            }
            else {
                self.fetching[id] = [f]
                missing.append(id)
            }
        }
        
        if !missing.isEmpty {
            self.factory(keys: missing, fetcher: { objs in
                self.persist.write {
                    self.persist.realm.add(objs.values, update: true)
                }
                
                self.fork(ids, objs: objs)
            })
        }
    }
    
    private func fork(ids: [Int], objs: [Int: T]) {
        var forks: [Int: [ForkFunc]] = [:]
        for (id, _) in objs {
            if let fork = self.fetching[id] {
                forks[id] = fork
                self.fetching.removeValueForKey(id)
            }
        }
        
        for (id, obj) in objs {
            if let fork = forks[id] {
                for ff in fork {
                    ff?(id, obj)
                }
            }
        }
    }
}