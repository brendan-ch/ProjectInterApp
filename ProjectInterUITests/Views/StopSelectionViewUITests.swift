//
//  StopSelectionViewUITests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.03.04.
//

import XCTest

final class StopSelectionViewUITests: BaseUITests {
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app.launchArguments += ["-setupCompleted", "1"]
    }
    
    func testOpenAndClosingFlow() {
        app.launch()
        
        var _ = app.buttons["Change stop"].waitForExistence(timeout: 20)
        app.buttons["Change stop"].tap()
        
        let cellExists = app.collectionViews["StopSelectionCollectionView"].cells.firstMatch.waitForExistence(timeout: 20)
        XCTAssertTrue(cellExists)
        
        _ = app.buttons["Close"].waitForExistence(timeout: 20)
        app.buttons["Close"].tap()
        
        let cellNoLongerExists = app.collectionViews["StopSelectionCollectionView"].cells.firstMatch.waitForNonExistence(timeout: 20)
        
        XCTAssertTrue(cellNoLongerExists)
    }
}
