//
//  Enhanced_Magic_8_BallUITests.swift
//  Enhanced Magic 8 BallUITests
//
//  Created by John Hoaglun on 9/23/26.
//

import XCTest

final class Enhanced_Magic_8_BallUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testShakeRevealsAnswerAndAskAgainReturnsToIdle() throws {
        let app = XCUIApplication()
        app.launch()

        let shakeButton = app.buttons["Shake the Ball"]
        XCTAssertTrue(shakeButton.waitForExistence(timeout: 5))
        shakeButton.tap()

        let askAgainButton = app.buttons["Ask Again"]
        XCTAssertTrue(askAgainButton.waitForExistence(timeout: 5))
        askAgainButton.tap()

        XCTAssertTrue(shakeButton.waitForExistence(timeout: 5))
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
