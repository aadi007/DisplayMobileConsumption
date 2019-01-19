//
//  Record.swift
//  DisplayData
//
//  Created by Aadesh Maheshwari on 1/18/19.
//  Copyright © 2019 Aadesh Maheshwari. All rights reserved.
//

import UIKit
import ObjectMapper

struct Record: Mappable {
    var mobileDataVolume: String?
    var quarter: String?
    var id: Int?
    var fullCount: String?
    var rank: Float?
    var decreasedVolume = false
    
    init?(map: Map) {
    }
    mutating func mapping(map: Map) {
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

class YearRecord {
    var quaters: [Record]
    var totalVolumeConusmed: String
    var year: String
    var performannceDecreased = false
    init(quaters: [Record], year: String) {
        self.quaters = quaters
        self.year = year
        self.totalVolumeConusmed = quaters.map({ Float($0.mobileDataVolume!)!}).reduce(0, { x, y in
            x + y
        }).description
        calculateQuatersPerformance()
    }
    func calculateQuatersPerformance() {
        let quaterVolumes = quaters.map({ Float($0.mobileDataVolume!)! })
        if !quaterVolumes.isEmpty {
            var minimumValue: Float = 0.0
            for index in 0..<quaterVolumes.count {
                let volume = quaterVolumes[index]
                if volume < minimumValue {
                    //set the volume for this year decreased
                    self.performannceDecreased = true
                    self.quaters[index].decreasedVolume = true
                }
                minimumValue = volume
            }
        }
    }
}
