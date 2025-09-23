//
//  RouteInfoTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.03.24.
//

import XCTest
import ProjectInterOperations
import ProjectInterTestMocks
import ApolloTestSupport

final class RouteInfoUITests: BaseUITests {
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
    
    @MainActor
    func assertButtonsInNotificationTimeframeSheetResultInRefresh() async {
        // Assumes the sheet is already open
        let sheet = app.sheets["Select a timeframe"].otherElements
        
        let availableOptions = getAvailableOptionsWithinSheet(sheet)
        
        XCTAssertFalse(availableOptions.isEmpty, "No notification time options found in sheet")
        
        for optionText in availableOptions {
            // Extract the number from "X minutes" format
            let components = optionText.components(separatedBy: " ")
            guard let minuteValue = Int(components.first ?? "invalid") else {
                XCTFail("Could not parse minute value from: \(optionText)")
                continue
            }
            
            
            let expectedCancelText = "Cancel \(minuteValue)-minute notification"
            
            // To get it to show up when refreshing the view model,
            // mock before tapping
            await mockShuttleInfoQueryAndResponse(.init(secondsRemaining: 750, secondsThresholdForNotification: minuteValue * 60))
            sheet.buttons[optionText].tap()
            
            // Verify the button text changes to the cancel format
            XCTAssert(app.buttons[expectedCancelText].waitForExistence(timeout: 10),
                      "Expected button with text '\(expectedCancelText)' not found after tapping '\(optionText)'")
            
            // Cancel the notification to reset for the next test
            await mockShuttleInfoQueryAndResponse(.init(secondsRemaining: 750, secondsThresholdForNotification: nil))
            app.buttons[expectedCancelText].tap()
            
            // Verify it goes back to the original state
            XCTAssert(app.buttons["Notify me when nearby"].waitForExistence(timeout: 10),
                      "Button should return to 'Notify me when nearby' state after canceling")
            
            // Re-open the sheet for the next iteration (if there are more options)
            if optionText != availableOptions.last {
                app.buttons["Notify me when nearby"].tap()
            }
        }
    }
    
    // MARK: - Shared navigation
    func navigateToShuttlePage() {
        selectStopFromRouteList(name: "Chapman Court")
        selectFirstMatchButton(textIdentifier: "Red Route")
        selectFirstMatchButton(textIdentifier: "Shuttle 1")
    }
    
    @MainActor
    func testShuttleInfoIsShownWhenTapped() async {
        useMockNotificationsToken()
        
        await mockGetAllStopsQueryAndResponse()
        await mockGetRouteListQueryAndResponse()
        await mockGetRouteInfoDataQueryAndResponse()
        await mockShuttleInfoQueryAndResponse(.init(
            secondsRemaining: 150
        ))
        
        app.launch()
        navigateToShuttlePage()
        
        XCTAssert(app.staticTexts["Shuttle 1"].firstMatch.waitForExistence(timeout: 5))
        XCTAssert(app.staticTexts["2 min to Chapman Court"].firstMatch.waitForExistence(timeout: 5))
    }
    
    @MainActor
    func testNotificationMenuButtonsAndCancelButtonResultInRefresh() async {
        useMockNotificationsToken()
        
        await mockGetAllStopsQueryAndResponse()
        await mockGetRouteListQueryAndResponse()
        await mockGetRouteInfoDataQueryAndResponse()
        await mockShuttleInfoQueryAndResponse(.init(
            secondsRemaining: 750
        ))
        
        app.launch()
        navigateToShuttlePage()
        
        let notifyMeWhenNearbyStaticText = app.staticTexts["Notify me when nearby"]
        notifyMeWhenNearbyStaticText.tap()
        
        await assertButtonsInNotificationTimeframeSheetResultInRefresh()
    }

    
    // MARK: - Tests
    @MainActor
    func testShuttleListRendering() async {
        await mockGetAllStopsQueryAndResponse()
        await mockGetRouteListQueryAndResponse()
        await mockGetRouteInfoDataQueryAndResponse()
        
        app.launch()
        
        selectStopFromRouteList(name: "Chapman Court")
        selectFirstMatchButton(textIdentifier: "Red Route")
        
        XCTAssert(app.staticTexts["Shuttle 1"].firstMatch.waitForExistence(timeout: 5))
        XCTAssert(app.staticTexts["Shuttle 2"].firstMatch.waitForExistence(timeout: 5))
    }
    

    
    @MainActor
    func testRouteInfoIsClosedWhenCloseButtonTapped() async {
        await mockGetAllStopsQueryAndResponse()
        await mockGetRouteListQueryAndResponse()
        await mockGetRouteInfoDataQueryAndResponse()

        app.launch()
        
        selectStopFromRouteList(name: "Chapman Court")
        selectFirstMatchButton(textIdentifier: "Red Route")
        
        let _ = app.buttons["Close"].waitForExistence(timeout: 5)
        app.buttons["Close"].tap()
        
        XCTAssert(app.buttons["Shuttle 1"].waitForNonExistence(timeout: 5))
        XCTAssert(app.buttons["Shuttle 2"].waitForNonExistence(timeout: 5))
    }
}
