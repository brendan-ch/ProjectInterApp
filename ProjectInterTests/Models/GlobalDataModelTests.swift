//
//  GlobalDataStateTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2024.12.30.
//

import Testing
@testable import ProjectInter
import ApolloTestSupport
import ProjectInterTestMocks

// TODO: Split GlobalDataModel into multiple classes for easier testing
class GlobalDataModelTests {
    @Test func testRefreshSystemDataWithCallback() async throws {
        var callbackCalled = false
        func callback() {
            callbackCalled = true
        }
        
        let mockClient = MockApolloClient()
        
        let mock = Mock<ProjectInterTestMocks.Query>(
            systems: [
                Mock<ProjectInterTestMocks.System>(
                    id: "1",
                    name: "Chapman University"
                ),
                Mock<ProjectInterTestMocks.System>(
                    id: "2",
                    name: "City of Monterey Park"
                ),
            ]
        )
        mockClient.mock = mock

        let globalDataState = GlobalDataModel(apolloClient: mockClient)
        globalDataState.refreshSystemData(callback: callback)
        
        #expect(globalDataState.systems.count == 2)
        #expect(callbackCalled == true)
   }
}
