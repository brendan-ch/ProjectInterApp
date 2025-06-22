//
//  ShuttleInfoUITests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.02.
//

import XCTest

final class ShuttleInfoUITests: BaseUITests {
    override func setUpWithError() throws {
        try super.setUpWithError()
        skipSetupFlow()
    }
    
    func assertButtonsInNotificationTimeframeSheetResultInUIUpdate() {
        let expectedTextForEachButtonText: [String: String] = [
            "2 minutes": "Cancel 2-minute notification",
            "5 minutes": "Cancel 5-minute notification",
            "10 minutes": "Cancel 10-minute notification",
        ]
        
        // Assumes the sheet is already open
        
        let sheet = app.sheets["Select a timeframe"].otherElements
        let buttons = sheet.buttons
        
        for (key, value) in expectedTextForEachButtonText {
            buttons[key].tap()
            
            XCTAssert(app.buttons[value].waitForExistence(timeout: 10))
            
            app.buttons[value].tap()
            app.buttons["Notify me when nearby"].tap()
        }
    }
    
    func testNotificationMenuButtonsAndCancelButtonResultInButtonTextUpdate() {
        useMockNotificationsToken()
        app.launch()
        
        var notificationButtonEnabled = false
        
        executeCallbackForEachStop(shouldExitCallbackLoop: {
            executeCallbackForEachShuttle(shouldExitCallbackLoop: {
                let notifyMeWhenNearbyStaticText = app.staticTexts["Notify me when nearby"]
                let notificationButtonExists = notifyMeWhenNearbyStaticText.waitForExistence(timeout: 5)
                
                if notificationButtonExists && notifyMeWhenNearbyStaticText.isEnabled {
                    notificationButtonEnabled = true
                    return true
                } else {
                    // Button doesn't exist or is disabled, try another shuttle
                    return false
                }
            })
            
            // If we found an enabled notification button, exit the stop loop
            return notificationButtonEnabled
        })
        
        if !notificationButtonEnabled {
            XCTFail("No shuttles with enabled notification button found")
        }
        
        let notifyMeWhenNearbyStaticText = app.staticTexts["Notify me when nearby"]
        notifyMeWhenNearbyStaticText.tap()
        
        assertButtonsInNotificationTimeframeSheetResultInUIUpdate()
    }
}
