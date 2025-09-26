//
//  StopSelectionViewUITests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.03.04.
//

import XCTest

final class StopSelectionUITests: BaseUITests {
    override func setUpWithError() throws {
        try super.setUpWithError()
        skipSetupFlow()
        selectDefaultSystem()
    }
    
    @MainActor
    func testOpenAndClosingFlowWithoutAnyRoutes() async {
        await mockGetAllStopsQueryAndResponse()
        
        app.launch()
        
        var _ = app.buttons["Change stop"].waitForExistence(timeout: 20)
        app.buttons["Change stop"].tap()
        
        XCTAssert(app.collectionViews.cells.staticTexts["No stops found."].waitForNonExistence(timeout: 5))

        XCTAssert(app.collectionViews.cells.buttons["Chapman Court"].waitForExistence(timeout: 5))

        app.buttons["Close"].tap()
        
        let cellNoLongerExists = app.collectionViews.cells.buttons["Chapman Court"].waitForNonExistence(timeout: 5)
        
        XCTAssertTrue(cellNoLongerExists)
    }
}
