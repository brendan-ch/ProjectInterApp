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
    
    
    func attemptToSelectShuttleButton() -> Bool {
        let firstMatchExists = app.otherElements.buttons["Shuttle"].waitForExistence(timeout: 20)
        if !firstMatchExists {
            return false
        }
        
        sleep(5)
        
        app.buttons["Shuttle"].firstMatch.forceTapElement()
        let shuttleTextExists = app.staticTexts["Shuttle name"].firstMatch.waitForExistence(timeout: 5)
        if !shuttleTextExists {
            // Handle cases where the selected stop may be blocking the shuttle,
            // in which case the map should handle the correct selection the second time
            app.buttons["Shuttle"].firstMatch.forceTapElement()
        }
        
        return true
    }
    
    func testRouteIsShownWhenRouteIsSelected() {
        app.launch()
        
        executeCallbackForEachStop(shouldExitCallbackLoop: {
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
        })
    }
    
    func testUnrelatedShuttlesAreHiddenWhenRouteIsSelected() {
        app.launch()
        
        executeCallbackForEachStop(shouldExitCallbackLoop: {
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
        })
    }
    
    func testTapOnShuttleOpensShuttleInfo() {
        app.launch()
        
        var shuttleButtonTapped = false
        
        executeCallbackForEachStop(shouldExitCallbackLoop: {
            if !attemptToSelectShuttleButton() {
                return false
            }
            
            XCTAssert(app.staticTexts["Shuttle name"].firstMatch.waitForExistence(timeout: 20))
            shuttleButtonTapped = true
            return true
        })
        
        if !shuttleButtonTapped {
            XCTFail("No shuttle buttons found.")
        }
    }
    
    func testTapOnStopDeselectsShuttleAndHidesInfo() {
        app.launch()
        
        var shuttleButtonTapped = false
        
        executeCallbackForEachStop(shouldExitCallbackLoop: {
            if !attemptToSelectShuttleButton() {
                return false
            }

            let firstMatchStopButtonExists = app.otherElements.buttons["Stop"].waitForExistence(timeout: 20)
            if !firstMatchStopButtonExists {
                return false
            }
            
            XCTAssert(app.staticTexts["Shuttle name"].firstMatch.waitForExistence(timeout: 20))
            shuttleButtonTapped = true

            app.buttons["Stop"].firstMatch.tap()
            XCTAssert(app.staticTexts["Shuttle name"].firstMatch.waitForNonExistence(timeout: 20))
            
            return true
        })
        
        if !shuttleButtonTapped {
            XCTFail("No shuttle buttons found.")
        }
    }
}
