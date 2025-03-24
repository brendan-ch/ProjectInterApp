//
//  RouteInfoTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.03.24.
//

import XCTest

final class RouteInfoUITests: BaseUITests {
    override func setUpWithError() throws {
        try super.setUpWithError()
        app.launchArguments += ["-setupCompleted", "1"]
    }
    
    func testShuttleInfoIsShownWhenTapped() {
        app.launch()
        
        var shuttleInfoTapped = false
        
        executeCallbackForEachStop(shouldExitCallbackLoop: {
            if !checkIfRoutesExist() {
                return false
            }
            
            executeCallbackForEachRoute(shouldExitCallbackLoop: {
                let routeInfoShuttlesExist = app.buttons["Shuttle label in route info page"].waitForExistence(timeout: 5)
                if !routeInfoShuttlesExist {
                    return false
                }
                
                app.buttons["Shuttle label in route info page"].firstMatch.tap()
                
                XCTAssert(app.staticTexts["Shuttle name"].firstMatch.waitForExistence(timeout: 5))
                shuttleInfoTapped = true
                
                return true
            })
            
            if !shuttleInfoTapped {
                return false
            }
            return true
        })
        
        if !shuttleInfoTapped {
            XCTFail("No shuttles found in test data")
        }
    }
    
    func testRouteInfoIsClosedWhenCloseButtonTapped() {
        app.launch()
    }
}
