//
//  ShuttleInfoUITests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.02.
//

final class ShuttleInfoUITests: BaseUITests {
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app.launchArguments += ["setupCompleted", "1"]
    }
    
    func executeCallbackForEachNotificationButton() {
        
    }
    
    func testNotificationMenuButtonsAndCancelButtonResultInButtonTextUpdate() {
        // Cycle through all notification buttons, and the cancel button
    }
    
    func testNotificationMenuButtonIsHiddenIfShuttleIsNearby() {
        
    }
    
    func testNotificationButtonIsDisabledIfShuttleIsNearby() {
        
    }
}
