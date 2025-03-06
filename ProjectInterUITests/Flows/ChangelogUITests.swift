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
        
        // These launch arguments are automatically set in UserDefaults
        // https://sarunw.com/posts/how-to-set-userdefaults-value-with-launch-arguments/
        app.launchArguments += ["-setupCompleted", "1"]
    }
    
    func testOpenChangelogOpensTheWebView() {
        app.launch()
        
        let changelogButton = app.buttons["See what's new"]
        changelogButton.tap()
        
        let webView = app.webViews["ChangelogWebView"]
        
        // Assert WebView is displayed
        XCTAssertTrue(webView.waitForExistence(timeout: 5), "WebView did not launch")
        
        let text = webView.staticTexts.firstMatch
        XCTAssertTrue(text.waitForExistence(timeout: 10), "Page did not load")
    }
}
