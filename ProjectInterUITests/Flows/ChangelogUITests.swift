//
//  RouteListContentViewTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.02.18.
//

import XCTest

final class ChangelogUITests: BaseUITests {
    override func setUpWithError() throws {
        try super.setUpWithError()
        skipSetupFlow()
    }
    
    func testOpenChangelogOpensTheWebView() {
        app.launch()
        
        let changelogButton = app.buttons["See what's new"]
        changelogButton.tap()
        
        let webView = app.webViews["ChangelogWebView"]
        
        // Assert WebView is displayed
        XCTAssertTrue(webView.waitForExistence(timeout: 5), "WebView did not launch")
        
        let text = webView.staticTexts.firstMatch
        XCTAssertTrue(text.waitForExistence(timeout: 20), "Page did not load")
    }
}
