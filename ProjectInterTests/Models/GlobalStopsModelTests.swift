//
//  GlobalStopsModelTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.01.03.
//

import Testing
@testable import ProjectInter
import ApolloTestSupport
import ProjectInterTestMocks

class GlobalStopsModelTests {
    @Test func testRefreshStopDataWithValidData() async throws {
        let mockClient = MockApolloClient()
        
        let mock = Mock<ProjectInterTestMocks.Query>(
            system: Mock<ProjectInterTestMocks.System>(
                id: "1",
                name: "Chapman University",
                stops: [
                    Mock<ProjectInterTestMocks.Stop>(
                        id: "1",
                        name: "Panther Village"
                    ),
                    Mock<ProjectInterTestMocks.Stop>(
                        id: "2",
                        name: "Schmid Gate"
                    )
                ]
            )
        )
        mockClient.mock = mock

        let globalDataState = GlobalStopsModel(apolloClient: mockClient)
        let arguments = GlobalStopsNetworkArguments(systemId: "1")
        
        globalDataState.refreshData(arguments: arguments)
        
        #expect(globalDataState.stops.count == 2)
    }
    
    @Test func selectStopBasedOnClosestLocation() async throws {
        <#body#>
    }
}
