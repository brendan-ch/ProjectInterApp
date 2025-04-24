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
        app.launch()
        
        openSettingsTab()
        
        let changelogButton = app.buttons["See what's new"]
        changelogButton.tap()
        
        let webView = app.webViews["ChangelogWebView"]
        
        assertWebViewExistence(webView)
    }
    
    func testOpenFeedbackOpensTheWebView() {
        app.launch()
        
        openSettingsTab()
        
        let feedbackButton = app.buttons["Send feedback"]
        feedbackButton.tap()
        
        let webView = app.webViews["FeedbackWebView"]
        
        assertWebViewExistence(webView)
    }
    
    func testSystemSelectionOpenAndClosingFlow() {
        app.launch()
        
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
}
