//
//  ShuttleInfoUITests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.02.
//

import XCTest
import ProjectInterOperations
import ApolloTestSupport
import ProjectInterTestMocks

final class ShuttleInfoUITests: BaseUITests {
    override func setUpWithError() throws {
        try super.setUpWithError()
        skipSetupFlow()
    }
    
    // MARK: - Helpers
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
    
    // MARK: - Tests
    @MainActor
    func testShuttleInfoIsShownWhenTapped() async {
        await mockGetAllStopsQueryAndResponse()
        await mockGetRouteListQueryAndResponse()
        await mockGetRouteInfoDataQueryAndResponse()
        
        let shuttleInfoQuery = GetShuttleInfoDataQuery(
            systemId: defaultSystemId,
            shuttleId: "1",
            notificationInput: .init(
                deviceId: "1",
                shuttleId: "1",
                stopId: "1"
            )
        )
        let shuttleInfoResponse = Mock<Query>(
            secondsThresholdForNotification: 150,
            system: .init(
                shuttle: .init(
                    etas: [
                        .init(
                            secondsRemaining: 150,
                            stop: .init(
                                id: "1",
                                name: "Chapman Court"
                            )
                        )
                    ],
                    name: "Shuttle 1"
                )
            )
        )
        await client.mock(query: shuttleInfoQuery, response: shuttleInfoResponse)
        
        app.launch()
        
        selectStopFromRouteList(name: "Chapman Court")
        selectFirstMatchButton(textIdentifier: "Red Route")
        selectFirstMatchButton(textIdentifier: "Shuttle 1")
        
        XCTAssert(app.staticTexts["Shuttle name"].firstMatch.waitForExistence(timeout: 5))
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
