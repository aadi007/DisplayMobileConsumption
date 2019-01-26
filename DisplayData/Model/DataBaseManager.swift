//
//  DataBaseManager.swift
//  DisplayData
//
//  Created by Aadesh Maheshwari on 1/25/19.
//  Copyright © 2019 Aadesh Maheshwari. All rights reserved.
//

import UIKit
import RealmSwift

class DataBaseManager: NSObject {
    class func getRecordFor(year: String) -> YearRecord? {
        let realm = try! Realm()
        return realm.objects(YearRecord.self).filter("year == '\(year)'").first
    }
    class func storeYearRecord(yearRecord: YearRecord) {
        // Get the default Realm
        let realm = try! Realm()
        // Persist your data easily
        try! realm.write {
            realm.add(yearRecord)
        }
    }
    class func deleteRecords() {
        
    }
}
