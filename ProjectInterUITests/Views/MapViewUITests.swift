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
    
    func executeCallbackForEachStop(_ callback: () -> Bool) {
        app.buttons["Change stop"].tap()
        
        for cell in app.collectionViews.cells.allElementsBoundByIndex {
            cell.tap()
            
            let shouldExit = callback()
            if shouldExit {
                return
            }
            
            app.buttons["Change stop"].tap()
        }
    }
    
    func testRouteIsShownWhenRouteIsSelected() {
        app.launch()
        
        executeCallbackForEachStop {
            let routes = app.buttons.containing(NSPredicate(format: "label CONTAINS 'Route'"))
            
            if routes.allElementsBoundByIndex.isEmpty {
                return false
            }
            
            for route in routes.allElementsBoundByIndex {
                route.tap()
                
                let screenshot = XCUIScreen.main.screenshot()
                let attachment = XCTAttachment(screenshot: screenshot)
                attachment.lifetime = .keepAlways
                add(attachment)
                
                app.buttons["Close"].tap()
            }
            
            return true
        }
    }
    
    func testUnrelatedShuttlesAreHiddenWhenRouteIsSelected() {
        app.launch()
        
    }
    
    func testTapOnShuttleOpensShuttleInfo() {
        app.launch()
        
        var shuttleButtonTapped = false
        
        executeCallbackForEachStop {
            let firstMatch = app.otherElements.buttons["Shuttle"].firstMatch
            
            if firstMatch.waitForExistence(timeout: 5) {
                firstMatch.tap()
                XCTAssert(app.staticTexts["Shuttle name"].firstMatch.waitForExistence(timeout: 5))
                shuttleButtonTapped = true
                return true
            }
            
            return false
        }
        
        if !shuttleButtonTapped {
            XCTFail("No shuttle buttons found.")
        }
    }
}
