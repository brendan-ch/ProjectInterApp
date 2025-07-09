//
//  RouteInfoTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.03.24.
//

import XCTest
import ProjectInterOperations
import ProjectInterTestMocks
import ApolloTestSupport

final class RouteInfoUITests: BaseUITests {
    override func setUpWithError() throws {
        try super.setUpWithError()
        skipSetupFlow()
    }
    
    // MARK: - Tests
    @MainActor
    func testShuttleListRendering() async {
        await mockGetAllStopsQueryAndResponse()
        await mockGetRouteListQueryAndResponse()
        await mockGetRouteInfoDataQueryAndResponse()
        
        app.launch()
        
        selectStopFromRouteList(name: "Chapman Court")
        selectFirstMatchButton(textIdentifier: "Red Route")
        
        XCTAssert(app.staticTexts["Shuttle 1"].firstMatch.waitForExistence(timeout: 5))
        XCTAssert(app.staticTexts["Shuttle 2"].firstMatch.waitForExistence(timeout: 5))
    }
    

    
    @MainActor
    func testRouteInfoIsClosedWhenCloseButtonTapped() async {
        await mockGetAllStopsQueryAndResponse()
        await mockGetRouteListQueryAndResponse()
        await mockGetRouteInfoDataQueryAndResponse()

        app.launch()
        
        selectStopFromRouteList(name: "Chapman Court")
        selectFirstMatchButton(textIdentifier: "Red Route")
        
        let _ = app.buttons["Close"].waitForExistence(timeout: 5)
        app.buttons["Close"].tap()
        
        XCTAssert(app.buttons["Shuttle 1"].waitForNonExistence(timeout: 5))
        XCTAssert(app.buttons["Shuttle 2"].waitForNonExistence(timeout: 5))
    }
}
