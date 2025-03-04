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
import CoreLocation

class GlobalStopsModelTests {
    @Test func testRefreshStopDataWithValidDataAndSorting() async throws {
        let mockClient = MockApolloClient()
        
        let mock = Mock<ProjectInterTestMocks.Query>(
            system: Mock<ProjectInterTestMocks.System>(
                id: "1",
                name: "Chapman University",
                stops: [
                    Mock<ProjectInterTestMocks.Stop>(
                        // 33.793316, -117.852825
                        coordinates: Mock<ProjectInterTestMocks.Coordinates>(
                            latitude: 33.793316,
                            longitude: -117.852825
                        ),
                        id: "2",
                        name: "Schmid Gate"
                    ),
                    Mock<ProjectInterTestMocks.Stop>(
                        // 33.789730, -117.886539
                        coordinates: Mock<ProjectInterTestMocks.Coordinates>(
                            latitude: 33.789730,
                            longitude: -117.886539
                        ),
                        id: "1",
                        name: "Panther Village"
                    )
                ]
            )
        )
        mockClient.queryMock = mock

        let globalStopsModel = GlobalStopsModel(apolloClient: mockClient)
        let arguments = GlobalStopsNetworkArguments(systemId: "1")
        
        await globalStopsModel.refreshDataOnce(arguments: arguments)
        
        #expect(globalStopsModel.stops.count == 2)
        #expect(globalStopsModel.stops[0].name == "Panther Village")
        #expect(globalStopsModel.stops[1].name == "Schmid Gate")
    }
    
    @Test func selectStopBasedOnClosestLocation() async throws {
        let stops: [ProjectInter.Stop] = [
            ProjectInter.Stop(
                name: "Panther Village",
                id: "1",
                coordinates: RawCoordinates(latitude: 33.789730, longitude: -117.886539)
            ),
            ProjectInter.Stop(
                name: "Schmid Gate",
                id: "2",
                coordinates: RawCoordinates(latitude: 33.793316, longitude: -117.852825)
            )
        ]
        
        let state = GlobalStopsModel()
        state.stops = stops
        
        state.selectClosestStopBasedOnLocation(
            location: CLLocationCoordinate2D(latitude: stops[0].coordinates.latitude, longitude: stops[0].coordinates.longitude)
        )
        
        #expect(state.selectedStop == stops[0])
    }
    
    @Test func selectStopBasedOnClosestLocationWithNoStopsAvailable() async throws {
        let state = GlobalStopsModel()
        state.selectClosestStopBasedOnLocation(
            location: CLLocationCoordinate2D(latitude: 33.789730, longitude: -117.886539)
        )
        
        #expect(state.selectedStop == nil)
    }
}
