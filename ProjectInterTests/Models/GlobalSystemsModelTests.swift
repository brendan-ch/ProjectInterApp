//
//  GlobalDataStateTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2024.12.30.
//

import Foundation
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
    
    @Test func testUpdateSystemIdUpdatesSelectedSystemAndUserDefaults() async {
        let mockUserDefaults = MockUserDefaults()
        
        let state = GlobalSystemsModel(apolloClient: nil, userDefaults: mockUserDefaults)
        state.systems = [
            .init(name: "Chapman University", id: "1"),
            .init(name: "CSULB", id: "2")
        ]
        
        state.selectSystemId("2")
        
        #expect(state.selectedSystem?.name == "CSULB")
        #expect(mockUserDefaults.lastKeySetTo == UserDefaults.selectedSystemIdKey)
        #expect(mockUserDefaults.lastValueSetTo as? String == "2")
    }
    
    // TODO: Add test for UserDefaults and state update
}
