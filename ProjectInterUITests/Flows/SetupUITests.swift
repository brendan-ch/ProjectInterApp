//
//  SetupUITests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.09.25.
//

import XCTest
@testable import ProjectInter

/// Control how the setup flow is performed.
struct SetupOptions {
    let shouldGrantLocationAccess: Bool
    let shouldGrantNotificationsAccess: Bool
}

final class SetupUITests: BaseUITests {
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        // During setup tests, we want to uninstall the app before running the test
        // This will reset any permissions we've set
        app.uninstallIfExists(name: "Interchange")
        
        app = XCUIApplication()
    }
    
    func performSetup(_ options: SetupOptions) {
        addUIInterruptionMonitor(withDescription: "Location and notification handlers") { element in
            let locationAllowButton = element.buttons["Allow While Using App"]
            if locationAllowButton.waitForExistence(timeout: 5) {
                // Location dialog
                if options.shouldGrantLocationAccess {
                    locationAllowButton.tap()
                } else {
                    let locationDenyButton = element.buttons["Don't Allow"]
                    if locationDenyButton.waitForExistence(timeout: 5) {
                        locationDenyButton.tap()
                    } else {
                        return false
                    }
                }
                
                return true
            }
            
            let notificationAllowButton = element.buttons["Allow"]
            if notificationAllowButton.waitForExistence(timeout: 5) {
                if options.shouldGrantNotificationsAccess {
                    notificationAllowButton.tap()
                } else {
                    let notificationDenyButton = element.buttons["Don't Allow"]
                    if notificationDenyButton.waitForExistence(timeout: 5) {
                        notificationDenyButton.tap()
                    } else {
                        return false
                    }
                }
                
                return true
            }
            
            return false
        }
        
        let continueButton = app.buttons["Continue"]
        if continueButton.waitForExistence(timeout: 10) {
            continueButton.tap()
        } else {
            XCTFail("Welcome screen button not found")
        }
        
        let locationScreenButton = options.shouldGrantLocationAccess ? app.buttons["Enable location access"] : app.buttons["Skip"]
        if locationScreenButton.waitForExistence(timeout: 10) {
            locationScreenButton.tap()
        } else {
            XCTFail("Location screen button not found")
        }
        app.swipeUp()

        let notificationScreenButton = app.buttons["Continue"]
        if notificationScreenButton.waitForExistence(timeout: 10) {
            notificationScreenButton.tap()
        } else {
            XCTFail("Notification screen button not found")
        }
        app.swipeUp()
        
        let pickSystemButton = app.buttons["Select system"]
        if pickSystemButton.waitForExistence(timeout: 5) {
            pickSystemButton.tap()
        } else {
            let changeSystemButton = app.buttons["Change system"]
            if changeSystemButton.waitForExistence(timeout: 5) {
                changeSystemButton.tap()
            } else {
                XCTFail("Select/change system button not found")
            }
        }
        
        let systemButton = app.collectionViews.cells.buttons["Chapman University"]
        if systemButton.waitForExistence(timeout: 10) {
            systemButton.tap()
        } else {
            XCTFail("No matching system found")
        }
        
        let systemScreenContinueButton = app.buttons["Continue"]
        systemScreenContinueButton.tap()
    }
    
    @MainActor
    func testSetupWithoutLocationAccessStillLoadsStop() async {
        await mockGetAllStopsQueryAndResponse()
        
        sleep(5)
        
        app.launch()
        performSetup(.init(
            shouldGrantLocationAccess: false,
            shouldGrantNotificationsAccess: true
        ))
        
        // Should be the first stop when loaded in alphabetical order
        let expectedStopName = app.staticTexts["Current stop: Chapman Court"]
        XCTAssert(expectedStopName.waitForExistence(timeout: 10))
    }
    
}
