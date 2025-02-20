//
//  MapViewUITests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.02.20.
//

import XCTest

final class MapViewUITests: BaseUITests {
    override func setUpWithError() throws {
        try super.setUpWithError()
        app.launchArguments += ["-setupCompleted", "1"]
    }
    
    func testRouteIsShownWhenRouteIsSelected() {
        app.launch()
    }
    
    func testUnrelatedShuttlesAreHiddenWhenRouteIsSelected() {
        app.launch()
    }
    
    func testTapOnShuttleOpensShuttleInfo() {
        app.launch()
        
        var shuttleButtonTapped = false
        
        app.buttons["Change stop"].tap()
        for cell in app.collectionViews.cells.allElementsBoundByIndex {
            cell.tap()
            
            let firstMatch = app.otherElements.images["Shuttle button"].firstMatch
            if firstMatch.waitForExistence(timeout: 5) {
                firstMatch.tap()
                XCTAssert(app.staticTexts["Shuttle name"].firstMatch.waitForExistence(timeout: 5))
                shuttleButtonTapped = true
                return
            }
            
            app.buttons["Change stop"].tap()
        }
        
        if !shuttleButtonTapped {
            XCTFail("No shuttle buttons found.")
        }
    }
}
