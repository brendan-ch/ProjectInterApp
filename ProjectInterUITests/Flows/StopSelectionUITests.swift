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
    }
    
    func testOpenAndClosingFlow() {
        app.launch()
        
        var _ = app.buttons["Change stop"].waitForExistence(timeout: 20)
        app.buttons["Change stop"].tap()
    
        XCTAssert(app.collectionViews.cells.staticTexts["No stops found."].waitForNonExistence(timeout: 5))

        let predicate = NSPredicate(format: "identifier BEGINSWITH 'StopSelectionCollectionSearchResultItem'")
        let cellExists = app.buttons.matching(predicate).firstMatch.waitForExistence(timeout: 20)
        XCTAssertTrue(cellExists)
        
        _ = app.buttons["Close"].waitForExistence(timeout: 20)
        app.buttons["Close"].tap()
        
        let cellNoLongerExists = app.buttons.matching(predicate).firstMatch.waitForNonExistence(timeout: 20)
        
        XCTAssertTrue(cellNoLongerExists)
    }
}
