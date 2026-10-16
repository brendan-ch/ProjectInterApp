//
//  ParkingStructuresListContentViewModelTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.18.
//

import Testing
@testable import ProjectInter
import ProjectInterOperations
import ProjectInterShared
import ApolloTestSupport
import ProjectInterTestMocks
import Foundation

class ParkingStructuresListContentViewModelTestsMockData {
    static let defaultArguments = ParkingStructuresNetworkingArguments(systemId: "1")

    static let defaultMock = Mock<ProjectInterTestMocks.Query>(
        system: .init(
            parkingSystem: .init(
                parkingStructures: [
                    .init(
                        capacity: 100,
                        id: "1",
                        name: "Anderson Structure",
                        spotsAvailable: 50
                    ),
                    .init(
                        capacity: 200,
                        id: "2",
                        name: "Barrera",
                        spotsAvailable: 100
                    )
                ]
            )
        )
    )

    static let secondaryMock = Mock<ProjectInterTestMocks.Query>(
        system: .init(
            parkingSystem: .init(
                parkingStructures: [
                    .init(
                        capacity: 500,
                        id: "3",
                        name: "Knott Studios Lot",
                        spotsAvailable: 100
                    ),
                    .init(
                        capacity: 350,
                        id: "4",
                        name: "Jim Miller Lot",
                        spotsAvailable: 12
                    )
                ]
            )
        )
    )

    static let tertiaryMock = Mock<ProjectInterTestMocks.Query>(
        system: .init(
            parkingSystem: nil
        )
    )
}

// Test the extension that is declared in the view model file
class ParkingStructuresListParkingStructureTests {
    @Test func apolloDataInitializerInitializesData() async {
        let data = await GetParkingStructuresListDataQuery.Data.from(ParkingStructuresListContentViewModelTestsMockData.defaultMock)
        let parkingStructures = data.system!.parkingSystem!.parkingStructures!

        let constructedStructures = parkingStructures.map(ParkingStructure.init)

        for i in 0..<constructedStructures.count {
            #expect(constructedStructures[i].id == parkingStructures[i].id)
            #expect(constructedStructures[i].name == parkingStructures[i].name)
            #expect(constructedStructures[i].spotsAvailable == parkingStructures[i].spotsAvailable)
            #expect(constructedStructures[i].capacity == constructedStructures[i].capacity)
        }
    }
}

class ParkingStructuresListContentViewModelTests {
    let defaultMock = ParkingStructuresListContentViewModelTestsMockData.defaultMock
    let tertiaryMock = ParkingStructuresListContentViewModelTestsMockData.tertiaryMock

    @Test("injectUpdate maps parking structures") func injectUpdateMapsStructures() async {
        let viewModel = ParkingStructuresListContentView.ViewModel()
        let data = await GetParkingStructuresListDataQuery.Data.from(defaultMock)

        await viewModel.injectUpdate(.success(data))

        #expect(viewModel.structures.count == 2)

        #expect(viewModel.structures[0].id == "1")
        #expect(viewModel.structures[1].id == "2")

        #expect(viewModel.structures[0].capacity == 100)
        #expect(viewModel.structures[1].capacity == 200)

        #expect(viewModel.structures[0].name == "Anderson Structure")
        #expect(viewModel.structures[1].name == "Barrera")

        #expect(viewModel.structures[0].spotsAvailable == 50)
        #expect(viewModel.structures[1].spotsAvailable == 100)

        #expect(viewModel.structuresSupportedBySystem)
    }

    @Test func injectUpdateSetsUnsupportedStatusIfNoParkingSystem() async {
        let viewModel = ParkingStructuresListContentView.ViewModel()
        let data = await GetParkingStructuresListDataQuery.Data.from(tertiaryMock)

        await viewModel.injectUpdate(.success(data))

        #expect(viewModel.structures.isEmpty)
        #expect(viewModel.structuresSupportedBySystem == false)
    }
}
