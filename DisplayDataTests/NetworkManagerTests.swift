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

    func testFetchRecordsHTTPStatusCode200() {
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
    // Asynchronous test: faster fail
    func testFetchRecordsCompletes() {
        let promise = expectation(description: "Completion handler invoked")
        var statusCode : Int?
        var responseError: String?
        networkManager.request(NetworkRouter.getData(resourceId: "807b7ab-6cad-4aa6-87d0-e283a7353a0f", limit: 4, query: "2008")) { result in
            switch result {
            case let .success(moyaResponse):
                statusCode = moyaResponse.statusCode
            case let .failure(error):
                responseError = error.errorDescription
            }
            promise.fulfill()
        }
        waitForExpectations(timeout: 30, handler: nil)
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            networkManager.request(NetworkRouter.getData(resourceId: "a807b7ab-6cad-4aa6-87d0-e283a7353a0f", limit: 4, query: "2008")) { _ in
            }
        }
    }

}
