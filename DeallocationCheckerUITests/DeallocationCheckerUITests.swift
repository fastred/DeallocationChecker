//
//  DeallocationCheckerUITests.swift
//  DeallocationCheckerUITests
//
//  Created by Arkadiusz Holko on 22/09/2018.
//  Copyright © 2018 Arkadiusz Holko. All rights reserved.
//

import XCTest

class DeallocationCheckerUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()
    }

    func testLeakingSwiftInNavigationController() {
        app.buttons["Show Leaking"].tap()
        app.buttons["Back"].tap()
        let text = app.staticTexts["Leak Status"]
        _ = text.waitForExistence(timeout: 4.0)
        XCTAssert(app.staticTexts["leaked"].exists)
    }

    func testLeakingObjCInNavigationController() {
        app.buttons["Show Leaking Obj-C"].tap()
        app.buttons["Back"].tap()
        let text = app.staticTexts["Leak Status"]
        _ = text.waitForExistence(timeout: 4.0)
        XCTAssert(app.staticTexts["leaked"].exists)
    }

    func testNotLeakingInNavigationController() {
        app.buttons["Show Not Leaking"].tap()
        app.buttons["Back"].tap()
        let text = app.staticTexts["Leak Status"]
        _ = text.waitForExistence(timeout: 4.0)
        XCTAssert(app.staticTexts["notLeaked"].exists)
    }

    func testNotLeakingWhenSwitchingTab() {
        app.buttons["Show Leaking"].tap()
        app.buttons["Second"].tap()
        let text = app.staticTexts["Leak Status"]
        let expectatation = self.expectation(for: NSPredicate(format: "exists == true"), evaluatedWith: text, handler: nil)
        expectatation.isInverted = true

        waitForExpectations(timeout: 5.0, handler: nil)
    }
}
