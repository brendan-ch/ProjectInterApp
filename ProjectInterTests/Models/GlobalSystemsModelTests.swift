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

class GlobalSystemsModelTests {
    @Test func testRefreshSystemData() async throws {
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
        mockClient.queryMock = mock

        let globalDataState = GlobalSystemsModel(apolloClient: mockClient)
        await globalDataState.refreshSystemData()
        
        #expect(globalDataState.systems.count == 2)
    }
    
    @Test func testRefreshSystemDataWithInvalidData() async throws {
        let mockClient = MockApolloClient()
        mockClient.queryMock = nil
        
        let globalDataState = GlobalSystemsModel(apolloClient: mockClient)
        await globalDataState.refreshSystemData()
        
        #expect(globalDataState.systems.count == 0)
    }
}
