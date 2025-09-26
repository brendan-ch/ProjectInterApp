//
//  SetupUITests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.09.25.
//

import XCTest
@testable import ProjectInter

final class SetupUITests: BaseUITests {
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        enforceSetupFlow()
        
        // During setup tests, we want to uninstall the app before running the test
        app.uninstallIfExists(name: "Interchange")
    }
    
    @MainActor
    func testSetupWithoutLocationAccessStillLoadsStop() async {
        await mockGetAllStopsQueryAndResponse()
        
        app.launch()
    }
}
