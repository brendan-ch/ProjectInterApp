//
//  TabNavigationUITests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.17.
//

import XCTest
import ProjectInterTestMocks
import ApolloTestSupport
import ProjectInterOperations

final class ParkingStructuresUITests: BaseUITests {
    override func setUpWithError() throws {
        try super.setUpWithError()
        skipSetupFlow()
        selectDefaultSystem()
    }
    
    
    @MainActor
    func testParkingStructuresDisplay() async {
        await mockGetParkingStructuresListData()
        
        app.launch()
        
        let structuresButton = app.tabBars.buttons["Parking"]
        let parkingTabExists = structuresButton.waitForExistence(timeout: 10)
        XCTAssert(parkingTabExists)
        structuresButton.tap()
        
        
        XCTAssert(app.staticTexts["Anderson"].waitForExistence(timeout: 5))
        XCTAssert(app.staticTexts["100 available"].waitForExistence(timeout: 5))
        XCTAssert(app.staticTexts["50/100"].waitForExistence(timeout: 5))
        XCTAssert(app.staticTexts["Barrera"].waitForExistence(timeout: 5))
        XCTAssert(app.staticTexts["50 available"].waitForExistence(timeout: 5))
        XCTAssert(app.staticTexts["50/150"].waitForExistence(timeout: 5))
    }
}
