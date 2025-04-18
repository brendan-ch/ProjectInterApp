//
//  TabNavigationUITests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.17.
//

import XCTest

final class ParkingStructuresUITests: BaseUITests {
    override func setUpWithError() throws {
        try super.setUpWithError()
        skipSetupFlow()
    }
    
    func testParkingStructuresTabSelection() {
        app.launch()
        
        let structuresButton = app.tabBars.buttons["Parking"]
        let parkingTabExists = structuresButton.waitForExistence(timeout: 10)
        XCTAssert(parkingTabExists)
        structuresButton.tap()
        
        let structuresHeading = app.staticTexts["Structures"]
        let structuresHeadingExists = structuresHeading.waitForExistence(timeout: 10)
        XCTAssert(structuresHeadingExists)
    }
}
