//
//  Record.swift
//  DisplayData
//
//  Created by Aadesh Maheshwari on 1/18/19.
//  Copyright © 2019 Aadesh Maheshwari. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift
import Realm

class Record: Object, Mappable {
    @objc dynamic var mobileDataVolume: String?
    @objc dynamic var quarter: String?
    @objc dynamic var id: Int = 0
    @objc dynamic var fullCount: String?
    @objc dynamic var rank: Double = 0.0
    @objc dynamic var decreasedVolume = false
    required convenience init?(map: Map) {
        self.init()
    }
    func mapping(map: Map) {
        mobileDataVolume                <- map["volume_of_mobile_data"]
        quarter                       <- map["quarter"]
        id                           <- map["_id"]
        fullCount                      <- map["_full_count"]
        rank                          <- map["rank"]
    }
}

struct DataFetchAPIResponse: Mappable {
    var records: [Record]?
    var total: Int?
    init?(map: Map) {
    }
    mutating func mapping(map: Map) {
        records                     <- map["result.records"]
        total                       <- map["total"]
    }
}

class YearRecord: Object {
    var quaters = List<Record>()
    @objc dynamic var totalVolumeConusmed = ""
    @objc dynamic var year = ""
    @objc dynamic var performannceDecreased = false
    required init() {
       super.init()
    }
    init(quaters: [Record], year: String) {
        super.init()
        var minimumValue: Double = 0.0
        for quater in quaters {
            let realmQuater = Record()
            realmQuater.mobileDataVolume = quater.mobileDataVolume
            realmQuater.decreasedVolume = quater.decreasedVolume
            if let volume = Double(quater.mobileDataVolume!) {
                if volume < minimumValue {
                    //set the volume for this year decreased
                    self.performannceDecreased = true
                    realmQuater.decreasedVolume = true
                }
                minimumValue = volume
            }
            realmQuater.quarter = quater.quarter
            realmQuater.id = quater.id
            realmQuater.fullCount = quater.fullCount
            realmQuater.rank = quater.rank
            self.quaters.append(realmQuater)
        }
        self.year = year
        self.totalVolumeConusmed = quaters.map({ Float($0.mobileDataVolume!)!}).reduce(0, { x, y in
            x + y
        }).description
    }
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        fatalError("init(realm:schema:) has not been implemented")
    }
    required init(value: Any, schema: RLMSchema) {
        fatalError("init(value:schema:) has not been implemented")
    }
}
