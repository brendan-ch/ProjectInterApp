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
import ProjectInterOperations
import ProjectInterShared
import CoreLocation

class GlobalStopsModelTestsMockData {
    static let defaultMock = Mock<ProjectInterTestMocks.Query>(
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
                    name: "Schmid Gate",
                    orderedStops: [
                        .init(
                            routeId: "1"
                        ),
                        .init(
                            routeId: "2"
                        )
                    ]
                ),
                Mock<ProjectInterTestMocks.Stop>(
                    // 33.789730, -117.886539
                    coordinates: Mock<ProjectInterTestMocks.Coordinates>(
                        latitude: 33.789730,
                        longitude: -117.886539
                    ),
                    id: "1",
                    name: "Panther Village",
                    orderedStops: [
                        .init(
                            routeId: "1"
                        ),
                        .init(
                            routeId: "2"
                        )
                    ]
                )
            ]
        )
    )
}

class GlobalStopsModelStopTests {
    @Test func apolloInitializerInitializesData() async throws {
        let data = await GetAllStopsBySystemIdQuery.Data.from(GlobalStopsModelTestsMockData.defaultMock)
        let stops = data.system!.stops!

        let constructedStops = stops.map(GlobalStopsModelStop.init)
        for i in 0..<constructedStops.count {
            #expect(stops[i].name == constructedStops[i].name)
            #expect(stops[i].id == constructedStops[i].id)
            #expect(stops[i].coordinates.latitude == constructedStops[i].coordinates.latitude)
            #expect(stops[i].coordinates.longitude == constructedStops[i].coordinates.longitude)

            guard let orderedStops = stops[i].orderedStops else { continue }
            for orderedStop in orderedStops {
                #expect(constructedStops[i].routeIds.contains(orderedStop.routeId))
            }
        }
    }
}

class GlobalStopsModelTests {
    @Test("injectUpdate maps and sorts stops by name") func injectUpdateMapsAndSortsStops() async {
        let model = GlobalStopsModel()
        let data = await GetAllStopsBySystemIdQuery.Data.from(GlobalStopsModelTestsMockData.defaultMock)

        await model.injectUpdate(.success(data))

        #expect(model.stops.count == 2)
        #expect(model.stops[0].name == "Panther Village")
        #expect(model.stops[1].name == "Schmid Gate")
    }

    @Test func automaticallySelectStopBasedOnClosestLocation() async throws {
        let stops: [ProjectInter.GlobalStopsModelStop] = [
            ProjectInter.GlobalStopsModelStop(
                name: "Panther Village",
                id: "1",
                coordinates: RawCoordinates(latitude: 33.789730, longitude: -117.886539)
            ),
            ProjectInter.GlobalStopsModelStop(
                name: "Schmid Gate",
                id: "2",
                coordinates: RawCoordinates(latitude: 33.793316, longitude: -117.852825)
            )
        ]

        let state = GlobalStopsModel()
        state.stops = stops

        state.automaticallySelectStop(
            for: CLLocationCoordinate2D(latitude: stops[0].coordinates.latitude, longitude: stops[0].coordinates.longitude)
        )

        #expect(state.selectedStop == stops[0])
    }

    @Test func automaticallySelectStopBasedOnClosestLocationWithNoStopsAvailable() async throws {
        let state = GlobalStopsModel()
        state.automaticallySelectStop(
            for: CLLocationCoordinate2D(latitude: 33.789730, longitude: -117.886539)
        )

        #expect(state.selectedStop == nil)
    }

    @Test func automaticallySelectStopWithoutLocationSetsFirstStop() async throws {
        let state = GlobalStopsModel()
        state.stops = [
            GlobalStopsModelStop(name: "Chapman Court", id: "1", coordinates: RawCoordinates(latitude: 33.796796, longitude: -117.889293)),
            GlobalStopsModelStop(name: "Schmid Gate", id: "2", coordinates: RawCoordinates(latitude: 33.793292, longitude: -117.852904))
        ]

        state.automaticallySelectStop()

        #expect(state.selectedStop?.name == "Chapman Court")
    }

    @Test func selectStopManuallySetsCorrectState() {
        let state = GlobalStopsModel()

        let stop = GlobalStopsModelStop(name: "Chapman Court", id: "1", coordinates: RawCoordinates(latitude: 33.789730, longitude: -117.886539))
        state.stops = [
            stop
        ]

        state.selectStopId(stop.id)

        #expect(state.selectedStop == stop)
        #expect(state.stopSelectionManuallyOverridenByUser == true)
    }
}
