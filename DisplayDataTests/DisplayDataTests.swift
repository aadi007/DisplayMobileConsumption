//
//  DisplayDataTests.swift
//  DisplayDataTests
//
//  Created by Aadesh Maheshwari on 1/18/19.
//  Copyright © 2019 Aadesh Maheshwari. All rights reserved.
//

import XCTest
@testable import DisplayData

class DisplayDataTests: XCTestCase {
    var dataDisplayViewController: DataDisplayViewController!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        dataDisplayViewController = DataDisplayViewController()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        dataDisplayViewController = nil
    }
    
    func testYearRecordsFunction() {
        let queryArray = dataDisplayViewController.viewModel.getYearsQueryArray()
        XCTAssertEqual(queryArray.count, 11, "There are other than 11 check here \(queryArray)")
    }
    
    func testFetchData() {
        dataDisplayViewController.viewModel.fetchData {
            let count = self.dataDisplayViewController.viewModel.records.count
            XCTAssertEqual(count, 1, "There are more or less than one record(s) for \(self.dataDisplayViewController.viewModel.records.first?.year ?? "2008")")
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
