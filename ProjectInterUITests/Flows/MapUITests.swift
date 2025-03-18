//
//  MapViewUITests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.02.20.
//

import XCTest

final class MapUITests: BaseUITests {
    override func setUpWithError() throws {
        try super.setUpWithError()
        app.launchArguments += ["-setupCompleted", "1"]
    }
    
    func executeCallbackForEachStop(_ callback: () -> Bool) {
        let _ = app.buttons["Change stop"].waitForExistence(timeout: 20)
        app.buttons["Change stop"].tap()
        
        XCTAssert(app.collectionViews.cells.staticTexts["No stops found."].waitForNonExistence(timeout: 5))
        
        let predicate = NSPredicate(format: "identifier BEGINSWITH 'StopSelectionCollectionSearchResultItem'")
        let sectionElements = app.buttons.matching(predicate).allElementsBoundByIndex
        
        for cell in sectionElements {
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
            let _ = routes.firstMatch.waitForExistence(timeout: 20)
            
            if routes.allElementsBoundByIndex.isEmpty {
                return false
            }
            
            for route in routes.allElementsBoundByIndex {
                route.tap()
                
                let screenshot = XCUIScreen.main.screenshot()
                let attachment = XCTAttachment(screenshot: screenshot)
                attachment.lifetime = .keepAlways
                add(attachment)
                
                let _ = app.buttons["Close"].waitForExistence(timeout: 5)
                app.buttons["Close"].tap()
            }
            
            return true
        }
    }
    
    func testUnrelatedShuttlesAreHiddenWhenRouteIsSelected() {
        app.launch()
        
        executeCallbackForEachStop {
            var shuttleCounts: [Int] = []
            let totalShuttleCount = app.otherElements.buttons.matching(identifier: "Shuttle").allElementsBoundByIndex.count
            
            let routes = app.buttons.containing(NSPredicate(format: "label CONTAINS 'Route'"))
            let _ = routes.firstMatch.waitForExistence(timeout: 20)
            if routes.count == 0 {
                return false
            }
            
            for route in routes.allElementsBoundByIndex {
                route.tap()
                
                let shuttleCount = app.otherElements.buttons.matching(identifier: "Shuttle").allElementsBoundByIndex.count
                shuttleCounts.append(shuttleCount)
                
                let _ = app.buttons["Close"].waitForExistence(timeout: 5)
                app.buttons["Close"].tap()
            }
            
            var calculatedShuttleCount = 0
            for count in shuttleCounts {
                calculatedShuttleCount += count
            }
            XCTAssert(totalShuttleCount == calculatedShuttleCount)
            
            return true
        }
    }
    
    // TODO: Find a more effective way to test annotation interactions
    
//    func testTapOnShuttleOpensShuttleInfo() {
//        app.launch()
//        
//        var shuttleButtonTapped = false
//        
//        executeCallbackForEachStop {
//            let firstMatchExists = app.otherElements.buttons["Shuttle"].waitForExistence(timeout: 20)
//            if !firstMatchExists {
//                return false
//            }
//            
//            app.buttons["Shuttle"].firstMatch.tap()
//            let shuttleTextExists = app.staticTexts["Shuttle name"].firstMatch.waitForExistence(timeout: 5)
//            if !shuttleTextExists {
//                app.buttons["Shuttle"].firstMatch.tap()
//            }
//            XCTAssert(app.staticTexts["Shuttle name"].firstMatch.waitForExistence(timeout: 20))
//            shuttleButtonTapped = true
//            return true
//        }
//        
//        if !shuttleButtonTapped {
//            XCTFail("No shuttle buttons found.")
//        }
//    }
}
