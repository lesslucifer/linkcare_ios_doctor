//
//  BaseMenuViewController.swift
//  DoctorApp
//
//  Created by Edward Nguyen on 4/30/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class Timing: Object {
    
    dynamic var mt_clinicTiming: ClinicTiming!
    dynamic var mt_Id: String!
    dynamic var mt_timefrom: String!
    dynamic var mt_timeto: String!
    dynamic var mt_timeOfSlot :Int = 0
    dynamic var mt_patientPerSlot :Int = 0
    
//    dynamic lazy var mt_key: String = self.makeKey();
//    private func makeKey() -> String {
//        return "\(mt_clinicTiming.mct_id)-\(mt_Id)"
//    }
    
    override class func primaryKey() -> String? {
        return "mt_Id"
    }
    
    var mt_repeatDate: [String]{
        get {
            return _listDate.map { $0.stringValue }
        }
        set {
            _listDate.removeAll()
            _listDate.appendContentsOf(newValue.map({ RealmString(value: [$0]) }))
        }
    }
    
    var mt_walkinDate: [String]{
        get {
            return _listWalkinDate.map { $0.stringValue }
        }
        set {
            _listWalkinDate.removeAll()
            _listWalkinDate.appendContentsOf(newValue.map({ RealmString(value: [$0]) }))
        }
    }
    
    let _listDate = List<RealmString>()
    let _listWalkinDate = List<RealmString>()
    
    override static func ignoredProperties() -> [String] {
        return ["mt_repeatDate","mt_walkinDate"]
    }
    
    convenience init(clinicTiming: ClinicTiming) {
        self.init()
        self.mt_clinicTiming = clinicTiming
    }
    
    convenience init(clinicTiming: ClinicTiming, id: String, start_at: String, end_at: String, time_slot: Int, overbooking: Int, repeatDate: [String],walkinDate: [String], destroy: String!) {
        self.init()
        self.mt_clinicTiming = clinicTiming
        self.mt_Id = id
        self.mt_timefrom = start_at
        self.mt_timeto = end_at
        self.mt_timeOfSlot = time_slot
        self.mt_patientPerSlot = overbooking
        self.mt_repeatDate = repeatDate
        self.mt_walkinDate = walkinDate
    }
    
    convenience init(clinicTiming: ClinicTiming, data:Dictionary<String, AnyObject>){
        self.init()
        self.mt_clinicTiming = clinicTiming
        self.mt_Id = String(data["id"] as! Int)
        self.mt_timefrom = !Utils.isEmpty(data["start_at"]) ? data["start_at"] as? String : ""
        self.mt_timeto = !Utils.isEmpty(data["end_at"]) ? data["end_at"] as? String : ""
        self.mt_timeOfSlot = data["time_slot"] as! Int
        self.mt_patientPerSlot = data["overbooking"] as! Int
        
        //-----
        let repeatDate = data["repeating_dates"]
        let aRepeatDate = NSArray(object: repeatDate!)
        let c = aRepeatDate.objectAtIndex(0) as! NSArray
        
        self.mt_repeatDate = c as! [String]
        //-----
        let walkinDate = data["walkin_dates"]
        let aWalkinDate = NSArray(object: walkinDate!)
        let d = aWalkinDate.objectAtIndex(0) as! NSArray
        
        self.mt_walkinDate = d as! [String]
    }
    
//    func mt_update(timeFrom: String, timeTo: String, timeSlot: String, patientPerSlot: String, destroy: String!) {
//        MMRealmHelper.sharedInstance.db_updateObject({
//            self.mt_timefrom = timeFrom
//            self.mt_timeto = timeTo
//            self.mt_timeOfSlot = Int(timeSlot)!
//            self.mt_patientPerSlot = Int(patientPerSlot)!
//        })
//    }
//
//    func mt_editTimeFrom(timeFrom: String){
//        MMRealmHelper.sharedInstance.db_updateObject {
//            self.mt_timefrom = timeFrom
//        }
//    }
//    
//    func mt_editTimeTo(timeTo: String){
//        MMRealmHelper.sharedInstance.db_updateObject {
//            self.mt_timeto = timeTo
//        }
//    }
//    
//    func mt_editTimeOfSlot(timeOfSlot: Int){
//        MMRealmHelper.sharedInstance.db_updateObject {
//            self.mt_timeOfSlot = timeOfSlot
//        }
//    }
//    
//    func mt_editPatientPerSlot(patientPerSlot: Int){
//        MMRealmHelper.sharedInstance.db_updateObject {
//            self.mt_patientPerSlot = patientPerSlot
//        }
//    }
//    
//    func updateRepeatDatesTest(date: [String]) {
//        MMRealmHelper.sharedInstance.db_updateObject {
//            self.mt_repeatDate = date
//        }
//    }
//    
//    func updateWalkinDatesTest(date: [String]) {
//        MMRealmHelper.sharedInstance.db_updateObject {
//            self.mt_walkinDate = date
//        }
//    }
    
//    static func mt_addNew(clinicTiming: ClinicTiming) -> Timing{
//        let timing = Timing(clinicTiming: clinicTiming)
//        timing.mt_Id = "tempID-\(Utils.getNowTimestamp())"
//        MMRealmHelper.sharedInstance.db_createObject(timing)
//        return timing
//    }
    
    func mt_isEmpty() -> Bool{
        return false
    }
}

enum repeatDate : Int {
    case mon = 2
    case tue = 3
    case wed = 4
    case thu = 5
    case fri = 6
    case sat = 7
    case sun = 8
    
    var description: String {
        switch self {
        case .mon:
            return "mon"
        case .tue:
            return "tue"
        case .wed:
            return "wed"
        case .thu:
            return "thu"
        case .fri:
            return "fri"
        case .sat:
            return "sat"
        case .sun:
            return "sun"
        }
    }
}

class RealmString: Object{
    dynamic var stringValue = ""
}

class TimingTemp: Object {
    dynamic var mtt_day: String!
    var mtt_timingList = List<Timing>()
    
    convenience init(day: String, timings: Array<Timing>) {
        self.init()
        self.mtt_day = day
        for timing in timings{
            self.mtt_timingList.append(timing)
        }
        
    }
}

