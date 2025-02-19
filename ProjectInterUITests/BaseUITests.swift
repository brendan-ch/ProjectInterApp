//
//  InterMVP1UITests.swift
//  InterMVP1UITests
//
//  Created by Brendan Chen on 2024.12.16.
//

import XCTest
import Foundation

final class BaseUITests: XCTestCase {
    var app: XCUIApplication?

    override func setUpWithError() throws {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app = XCUIApplication()
        // These launch arguments are automatically set in UserDefaults
        // https://sarunw.com/posts/how-to-set-userdefaults-value-with-launch-arguments/
        app?.launchArguments += ["-setupCompleted", "0"]
    }
    

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
}
