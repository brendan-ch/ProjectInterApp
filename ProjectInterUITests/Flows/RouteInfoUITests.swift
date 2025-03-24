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
        
        
    }
    
    func testRouteInfoIsClosedWhenCloseButtonTapped() {
        app.launch()
    }
}
