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
        dataDisplayViewController.viewModel = DataFetchViewModel(min: 2008, max: 2018, networkManager: NetworkProvider<NetworkRouter>(endpointClosure: networkEndPointClousure, stubClosure: NetworkProvider.delayedStub(1)))
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testYearRecordsFunction() {
        let queryArray = dataDisplayViewController.viewModel.getYearsQueryArray()
        XCTAssertEqual(queryArray.count, 11, "There are other than 11 check here \(queryArray)")
    }
    func testFetchDataWithStubResponse() {
        DataBaseManager.deleteRecords()
        let promise = expectation(description: "Status code: 200")
        var count = 0
        var error: String?
        dataDisplayViewController.viewModel.fetchData(completionHandler: { (errorMessage) in
            if errorMessage != nil {
                error = errorMessage
            } else {
                count = self.dataDisplayViewController.viewModel.records.count
            }
            promise.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(count, 1, "There are more or less than one record(s) for \(self.dataDisplayViewController.viewModel.records.first?.year ?? "2008") \(String(describing: error))")
    }
    func testFetchDataWithStoredData() {
        dataDisplayViewController.viewModel.fetchData(completionHandler: { (errorMessage) in
            if let message = errorMessage {
                XCTFail(message)
            } else {
                let count = self.dataDisplayViewController.viewModel.records.count
                XCTAssertEqual(count, 1, "There are more or less than one record(s) for \(self.dataDisplayViewController.viewModel.records.first?.year ?? "2008")")
            }
        })
    }
}
