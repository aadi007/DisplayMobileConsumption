//
//  NetworkManagerTests.swift
//  DisplayDataTests
//
//  Created by Aadesh Maheshwari on 1/26/19.
//  Copyright © 2019 Aadesh Maheshwari. All rights reserved.
//

import XCTest
@testable import DisplayData

class NetworkManagerTests: XCTestCase {
    var networkManager: NetworkProvider<NetworkRouter>!
    override func setUp() {
        networkManager = AppProvider.networkManager
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchRecordsAPI() {
        let promise = expectation(description: "Get quarter records for year 2008")
        networkManager.request(NetworkRouter.getData(resourceId: "a807b7ab-6cad-4aa6-87d0-e283a7353a0f", limit: 4, query: "2008")) { result in
            switch result {
            case let .success(moyaResponse):
                let statusCode = moyaResponse.statusCode
                if statusCode == 200 {
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            case let .failure(error):
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
        waitForExpectations(timeout: 30, handler: nil)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
