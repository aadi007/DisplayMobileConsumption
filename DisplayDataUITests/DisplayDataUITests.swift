//
//  DisplayDataUITests.swift
//  DisplayDataUITests
//
//  Created by Aadesh Maheshwari on 1/18/19.
//  Copyright © 2019 Aadesh Maheshwari. All rights reserved.
//

import XCTest

class DisplayDataUITests: XCTestCase {
    var app: XCUIApplication!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        app = XCUIApplication()
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launchArguments.append("--uitesting")

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRecordsList() {
        app.launch()
        swipeFor(staticText: "Q: 2008")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.swipeFor(staticText: "Q: 2010")
        }
    }
    func swipeFor(staticText: String) {
        app.tables.cells.staticTexts[staticText].swipeUp()
    }
}
