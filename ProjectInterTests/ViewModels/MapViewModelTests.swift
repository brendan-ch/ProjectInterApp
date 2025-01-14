//
//  MapViewModelTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.01.13.
//

import Testing
@testable import ProjectInter
import ApolloTestSupport
import ProjectInterTestMocks

class MapViewModelTests {
    @Test func refreshDataOnceRefreshesData() async {
        let mockClient = MockApolloClient()
        
        let mock = Mock<ProjectInterTestMocks.Query>(
            system: Mock<ProjectInterTestMocks.System>(
                routes: [
                    Mock<ProjectInterTestMocks.Route>(
                        color: "#ffffff", id: "1", polylineCoordinates: [
                            Mock<Coordinates>(
                                latitude: 1,
                                longitude: 1
                            ),
                            Mock<Coordinates>(
                                latitude: 2,
                                longitude: 2
                            )
                        ]
                    )
                ],
                shuttles: [
                    Mock<ProjectInterTestMocks.Shuttle>(
                        coordinates: Mock<Coordinates>(
                            latitude: 1,
                            longitude: 1
                        ),
                        id: "1",
                        name: "Shuttle 1", route: Mock<Route>(
                            color: "#ffffff",
                            id: "1"
                        )
                    ),
                ]
            )
        )
        mockClient.mock = mock
        
        let viewModel = MapViewModel(apolloClient: mockClient)
        let arguments = MapViewNetworkArguments(systemId: "1")
        
        await viewModel.refreshDataOnce(arguments: arguments)
        
        #expect(viewModel.routes.count == 1)
        #expect(viewModel.shuttles.count == 1)
    }
    
    @Test func refreshDataOnceDoesNothingIfNoData() async {
        
    }
    
    @Test func refreshDataOnceFailsGracefullyIfNoShuttles() async {
        
    }
    
    @Test func refreshDataOnceFailsGracefullyIfNoRoutes() async {
        
    }
}
