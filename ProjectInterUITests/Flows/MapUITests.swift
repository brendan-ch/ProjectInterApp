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
        skipSetupFlow()
    }
    
    
    func testRouteIsShownWhenRouteIsSelected() {
        app.launch()
        
        executeCallbackForEachStop(shouldExitCallbackLoop: {
            if !checkIfRoutesExist() {
                return false
            }
            
            executeCallbackForEachRoute(shouldExitCallbackLoop: {
                let screenshot = XCUIScreen.main.screenshot()
                let attachment = XCTAttachment(screenshot: screenshot)
                attachment.lifetime = .keepAlways
                add(attachment)
                
                // Run for every route
                return false
            })
            
            return true
        })
    }
    
    func testUnrelatedShuttlesAreHiddenWhenRouteIsSelected() {
        app.launch()
        
        executeCallbackForEachStop(shouldExitCallbackLoop: {
            var shuttleCounts: [Int] = []
            let totalShuttleCount = app.otherElements.buttons.matching(identifier: "Shuttle").allElementsBoundByIndex.count
            
            if !checkIfRoutesExist() {
                return false
            }
            
            executeCallbackForEachRoute(shouldExitCallbackLoop: {
                let shuttleCount = app.otherElements.buttons.matching(identifier: "Shuttle").allElementsBoundByIndex.count
                shuttleCounts.append(shuttleCount)
                
                return false
            })
            
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
    
    func testTapOnShuttleAfterDeselectOpensShuttleInfo() {
        app.launch()
        
        var shuttleButtonTapped = false
        
        executeCallbackForEachStop(shouldExitCallbackLoop: {
            if !attemptToSelectShuttleButton() {
                return false
            }
            
            XCTAssert(app.staticTexts["Shuttle name"].firstMatch.waitForExistence(timeout: 20))
            shuttleButtonTapped = true
            
            app.buttons["Close"].tap()
            
            if !attemptToSelectShuttleButton() {
                return false
            }
            
            XCTAssert(app.staticTexts["Shuttle name"].firstMatch.waitForExistence(timeout: 20))

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
