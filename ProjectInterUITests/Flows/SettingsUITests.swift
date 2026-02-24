//
//  RouteListContentViewTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.02.18.
//

import XCTest
@testable import ProjectInter

final class SettingsUITests: BaseUITests {
    override func setUpWithError() throws {
        try super.setUpWithError()
        skipSetupFlow()
        selectDefaultSystem()
    }
    
    func openSettingsTab() {
        let tabButton = app.tabBars.buttons["Settings"]
        let tabButtonExists = tabButton.waitForExistence(timeout: 10)
        XCTAssert(tabButtonExists)
        tabButton.tap()
    }
    
    func assertWebViewExistence(_ webView: XCUIElement) {
        // Assert WebView is displayed
        XCTAssertTrue(webView.waitForExistence(timeout: 5), "WebView did not launch")
        
        let text = webView.staticTexts.firstMatch
        XCTAssertTrue(text.waitForExistence(timeout: 20), "Page did not load")
    }
    
    func testOpenChangelogOpensTheWebView() {
        launchAppAndResetCustomServerUrl()
        
        openSettingsTab()
        
        let changelogButton = app.buttons["See what's new"]
        changelogButton.tap()
        
        let webView = app.webViews["ChangelogWebView"]
        
        assertWebViewExistence(webView)
    }
    
    func testOpenAcknowledgmentsOpensTheWebView() {
        launchAppAndResetCustomServerUrl()
        
        openSettingsTab()
        
        let acknowledgementsButton = app.buttons["View acknowledgments"]
        acknowledgementsButton.tap()
        
        let webView = app.webViews["AcknowledgmentsWebView"]
        
        assertWebViewExistence(webView)
    }
    
    func testSystemSelectionOpenAndClosingFlow() {
        launchAppAndResetCustomServerUrl()
        
        openSettingsTab()
        
        let app = XCUIApplication()
        app.tabBars["Tab Bar"].buttons["Settings"].tap()
        app.buttons.staticTexts["System"].tap()
        
        let predicate = NSPredicate(format: "identifier BEGINSWITH 'SystemSelectionCollectionSearchResultItem'")
        let cellExists = app.buttons.matching(predicate).firstMatch.waitForExistence(timeout: 20)
        XCTAssertTrue(cellExists)
        
        _ = app.buttons["Close"].waitForExistence(timeout: 20)
        app.buttons["Close"].tap()
    }
    
    @MainActor
    func testChangeServerUrlRefreshesTheApp() async {
        await mockGetAllStopsQueryAndResponse()
        await mockGetRouteListQueryAndResponse()
        launchAppAndResetCustomServerUrl()
        resetServerUrlIfNeeded()

        openSettingsTab()
        
        app.buttons["Change server URL"].tap()
        
        let serverUrlTextField = app.textFields["Server URL"]
        if !serverUrlTextField.waitForExistence(timeout: 10) {
            XCTFail("Server URL configuration view did not display")
        }
        
        serverUrlTextField.tap()
        serverUrlTextField.typeText("https://example.com")
        app.buttons["Save"].tap()
        
        app.tabBars["Tab Bar"].buttons["Shuttles"].tap()
        XCTAssert(app.staticTexts["Red Route"].waitForNonExistence(timeout: 5))
        
        openSettingsTab()
        app.buttons["Change server URL"].tap()
        app.buttons["Reset to default"].tap()
        app.buttons["Save"].tap()
        
        app.tabBars["Tab Bar"].buttons["Shuttles"].tap()
        XCTAssert(app.staticTexts["Red Route"].waitForExistence(timeout: 5))
    }
    
    func testChangeServerUrlShowsInvalidUrlMessage() {
        
    }
}
