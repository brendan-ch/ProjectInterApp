//
//  InterMVP1UITestsLaunchTests.swift
//  InterMVP1UITests
//
//  Created by Brendan Chen on 2024.12.16.
//

import XCTest
@testable import ProjectInter
import ApolloTestSupport
import ProjectInterOperations
import ProjectInterTestMocks

final class LaunchTests: XCTestCase {
    let mockServerClient = MockServerClient(url: .mockApiBaseUrl)

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() async throws {
        let query = GetAllSystemsQuery()
        let mock = Mock<ProjectInterTestMocks.Query>(
            systems: [
                .init(id: "1", name: "System 1"),
            ],
        )
        await mockServerClient.mock(query: query, response: mock)
        
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
