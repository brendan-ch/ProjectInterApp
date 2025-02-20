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
    
    func testRoutesAndShuttlesAreVisible() {
        
    }
    
    func testTapOnShuttleOpensShuttleInfo() {
        
    }
}
