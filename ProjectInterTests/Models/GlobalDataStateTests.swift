//
//  GlobalDataStateTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2024.12.30.
//

import Testing
@testable import ProjectInter

class GlobalDataStateTests {
    @Test func testRefreshSystemData() async throws {
        let mockClient = MockApolloClient()
        
        let globalDataState = GlobalDataState(apolloClient: mockClient)
        globalDataState.refreshSystemData()
        
        #expect(globalDataState.systems.count == 2)
   }
}
