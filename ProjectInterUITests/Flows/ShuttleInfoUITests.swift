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
    
    func getAvailableOptionsWithinSheet(_ sheet: XCUIElementQuery) -> [String] {
        // Buttons must be in "<#> minutes" format
        let allSheetButtons = sheet.buttons.allElementsBoundByIndex
        var availableOptions: [String] = []
        
        for button in allSheetButtons {
            let buttonLabel = button.label
            if buttonLabel.hasSuffix("minutes") {
                availableOptions.append(buttonLabel)
            }
        }
        
        return availableOptions
    }
    
    func assertButtonsInNotificationTimeframeSheetResultInUIUpdate() {
        // Assumes the sheet is already open
        let sheet = app.sheets["Select a timeframe"].otherElements
        
        let availableOptions = getAvailableOptionsWithinSheet(sheet)
        
        XCTAssertFalse(availableOptions.isEmpty, "No notification time options found in sheet")
        
        for optionText in availableOptions {
            // Extract the number from "X minutes" format
            let components = optionText.components(separatedBy: " ")
            guard let minuteValue = components.first else {
                XCTFail("Could not parse minute value from: \(optionText)")
                continue
            }
            
            let expectedCancelText = "Cancel \(minuteValue)-minute notification"
            
            // Tap the option
            sheet.buttons[optionText].tap()
            
            // Verify the button text changes to the cancel format
            XCTAssert(app.buttons[expectedCancelText].waitForExistence(timeout: 10), 
                     "Expected button with text '\(expectedCancelText)' not found after tapping '\(optionText)'")
            
            // Cancel the notification to reset for the next test
            app.buttons[expectedCancelText].tap()
            
            // Verify it goes back to the original state
            XCTAssert(app.buttons["Notify me when nearby"].waitForExistence(timeout: 5),
                     "Button should return to 'Notify me when nearby' state after canceling")
            
            // Re-open the sheet for the next iteration (if there are more options)
            if optionText != availableOptions.last {
                app.buttons["Notify me when nearby"].tap()
            }
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
