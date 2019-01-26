//
//  DatabasemanagerTests.swift
//  DisplayDataTests
//
//  Created by Aadesh Maheshwari on 1/26/19.
//  Copyright © 2019 Aadesh Maheshwari. All rights reserved.
//

import XCTest
import ObjectMapper
@testable import DisplayData

class DatabasemanagerTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPersistantRecord() {
        if DataBaseManager.getRecordFor(year: "2008") != nil {
            XCTAssert(true, "2008 record is present")
        } else {
            XCTFail("Error: NO record present")
        }
    }
    func testInsertYearRecord() {
        if let apiResponse = Mapper<DataFetchAPIResponse>().map(JSONfile: "RecordResponse.json"),
            let apiRecordsFetched = apiResponse.records  {
            let record = YearRecord()
            record.config(quaters: apiRecordsFetched, year: "2008")
            //store the data in persistent storage
            DataBaseManager.storeYearRecord(yearRecord: record)
            XCTAssert(true, "2008 record is insertion success")
        } else {
            XCTFail("Error: Insertion failure")
        }
    }
    func testRecordDeletion() {
        DataBaseManager.deleteRecords()
        XCTAssert(true, "Records deleted")
    }
}
