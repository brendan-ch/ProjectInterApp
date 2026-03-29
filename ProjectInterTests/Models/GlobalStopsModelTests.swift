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
    @Test func apolloInitializerInitializesData() {
        let data = GetAllStopsBySystemIdQuery.Data.from(GlobalStopsModelTestsMockData.defaultMock)
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
    let mock = GlobalStopsModelTestsMockData.defaultMock

    @Test func testRefreshStopDataWithValidDataAndSorting() async throws {
        let mockClient = MockApolloClient()
        mockClient.queryMock = mock
        
        let networkModel = ApolloNetworkModel(client: mockClient)

        let globalStopsModel = GlobalStopsModel(apolloNetworkModel: networkModel)
        let arguments = GlobalStopsNetworkArguments(systemId: "1")
        
        await globalStopsModel.refreshDataOnce(arguments: arguments)
        
        #expect(globalStopsModel.stops.count == 2)
        #expect(globalStopsModel.stops[0].name == "Panther Village")
        #expect(globalStopsModel.stops[1].name == "Schmid Gate")
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
        let mockClient = MockApolloClient()
        mockClient.queryMock = mock
        
        let networkModel = ApolloNetworkModel(client: mockClient)
        
        let globalStopsModel = GlobalStopsModel(apolloNetworkModel: networkModel)
        let arguments = GlobalStopsNetworkArguments(systemId: "1")
        
        await globalStopsModel.refreshDataOnce(arguments: arguments)
        globalStopsModel.automaticallySelectStop()
        
        #expect(globalStopsModel.selectedStop != nil)
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

// MARK: - Hidden stops integration tests

class GlobalStopsModelHiddenStopsTests {
    private func makeTestDefaults() -> UserDefaults {
        let suiteName = "dev.bchen.Inter.GlobalStopsModelHiddenStopsTests.\(UUID().uuidString)"
        return UserDefaults(suiteName: suiteName)!
    }

    private func makeStopsModel(hiddenStopsModel: HiddenStopsModel) -> GlobalStopsModel {
        let model = GlobalStopsModel(hiddenStopsModel: hiddenStopsModel)
        // Sorted alphabetically, matching processRefreshDataResult behavior
        model.stops = [
            GlobalStopsModelStop(
                name: "Chapman Court",
                id: "3",
                coordinates: RawCoordinates(latitude: 33.796796, longitude: -117.889293)
            ),
            GlobalStopsModelStop(
                name: "Panther Village",
                id: "1",
                coordinates: RawCoordinates(latitude: 33.789730, longitude: -117.886539)
            ),
            GlobalStopsModelStop(
                name: "Schmid Gate",
                id: "2",
                coordinates: RawCoordinates(latitude: 33.793316, longitude: -117.852825)
            )
        ]
        return model
    }

    @Test func visibleStopsExcludesHidden() {
        let hiddenModel = HiddenStopsModel(userDefaults: makeTestDefaults())
        let stopsModel = makeStopsModel(hiddenStopsModel: hiddenModel)

        // Set the current system so filtering is active
        let arguments = GlobalStopsNetworkArguments(systemId: "sys1")
        _ = stopsModel.convertNetworkArgumentsIntoQuery(arguments)

        hiddenModel.setStopHidden("1", inSystem: "sys1", hidden: true)

        #expect(stopsModel.visibleStops.count == 2)
        #expect(stopsModel.visibleStops.allSatisfy { $0.id != "1" })
    }

    @Test func hiddenStopsReturnsOnlyHidden() {
        let hiddenModel = HiddenStopsModel(userDefaults: makeTestDefaults())
        let stopsModel = makeStopsModel(hiddenStopsModel: hiddenModel)

        let arguments = GlobalStopsNetworkArguments(systemId: "sys1")
        _ = stopsModel.convertNetworkArgumentsIntoQuery(arguments)

        hiddenModel.setStopHidden("2", inSystem: "sys1", hidden: true)

        #expect(stopsModel.hiddenStops.count == 1)
        #expect(stopsModel.hiddenStops.first?.id == "2")
    }

    @Test func autoSelectSkipsHiddenStopsWithoutLocation() {
        let hiddenModel = HiddenStopsModel(userDefaults: makeTestDefaults())
        let stopsModel = makeStopsModel(hiddenStopsModel: hiddenModel)

        let arguments = GlobalStopsNetworkArguments(systemId: "sys1")
        _ = stopsModel.convertNetworkArgumentsIntoQuery(arguments)

        // Hide Chapman Court (first alphabetically)
        hiddenModel.setStopHidden("3", inSystem: "sys1", hidden: true)

        stopsModel.automaticallySelectStop()

        // Should select Panther Village (next visible stop alphabetically)
        #expect(stopsModel.selectedStop?.id == "1")
    }

    @Test func autoSelectSkipsHiddenStopsWithLocation() {
        let hiddenModel = HiddenStopsModel(userDefaults: makeTestDefaults())
        let stopsModel = makeStopsModel(hiddenStopsModel: hiddenModel)

        let arguments = GlobalStopsNetworkArguments(systemId: "sys1")
        _ = stopsModel.convertNetworkArgumentsIntoQuery(arguments)

        // Hide Panther Village which is closest to its own coordinates
        hiddenModel.setStopHidden("1", inSystem: "sys1", hidden: true)

        // Use Panther Village's coordinates — should select next closest visible stop
        stopsModel.automaticallySelectStop(
            for: CLLocationCoordinate2D(latitude: 33.789730, longitude: -117.886539)
        )

        #expect(stopsModel.selectedStop?.id != "1")
        #expect(stopsModel.selectedStop != nil)
    }

    @Test func allStopsHiddenAutoSelectsNil() {
        let hiddenModel = HiddenStopsModel(userDefaults: makeTestDefaults())
        let stopsModel = makeStopsModel(hiddenStopsModel: hiddenModel)

        let arguments = GlobalStopsNetworkArguments(systemId: "sys1")
        _ = stopsModel.convertNetworkArgumentsIntoQuery(arguments)

        hiddenModel.setStopHidden("1", inSystem: "sys1", hidden: true)
        hiddenModel.setStopHidden("2", inSystem: "sys1", hidden: true)
        hiddenModel.setStopHidden("3", inSystem: "sys1", hidden: true)

        stopsModel.automaticallySelectStop()

        #expect(stopsModel.selectedStop == nil)
    }

    @Test func visibleStopsReturnsAllWhenNoSystemId() {
        let hiddenModel = HiddenStopsModel(userDefaults: makeTestDefaults())
        let stopsModel = makeStopsModel(hiddenStopsModel: hiddenModel)

        // Don't set currentSystemId — all stops should be visible
        #expect(stopsModel.visibleStops.count == 3)
    }
}
