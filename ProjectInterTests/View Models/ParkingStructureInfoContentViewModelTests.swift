//
//  ParkingStructureInfoContentViewModelTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.08.06.
//

import Foundation
import Testing
@testable import ProjectInter
import ProjectInterShared
import ProjectInterOperations
import ApolloTestSupport
import ProjectInterTestMocks

enum MockData {
    static let defaultArguments = ParkingStructureNetworkingArguments(
        systemId: "1",
        parkingStructureId: "1"
    )

    static let calendar = Calendar.current
    static var oneWeekAgo: Date! {
        MockData.calendar.date(byAdding: .day, value: -7, to: Date())!
    }

    static let defaultMock = Mock<ProjectInterTestMocks.Query>(
        system: .init(
            parkingSystem: .init(
                parkingStructure: .init(
                    address: "300 E Walnut Ave, Orange, CA 92867 United States",
                    capacity: 100,
                    historicalAverages: [
                        .init(
                            averageSpotsAvailable: 80,
                            from: calendar.date(bySettingHour: 8, minute: 0, second: 0, of: MockData.oneWeekAgo)!,
                            to: calendar.date(bySettingHour: 10, minute: 0, second: 0, of: MockData.oneWeekAgo)!
                        ),
                        .init(
                            averageSpotsAvailable: 67,
                            from: calendar.date(bySettingHour: 10, minute: 0, second: 0, of: MockData.oneWeekAgo)!,
                            to: calendar.date(bySettingHour: 12, minute: 0, second: 0, of: MockData.oneWeekAgo)!
                        ),
                        .init(
                            averageSpotsAvailable: 55,
                            from: calendar.date(bySettingHour: 12, minute: 0, second: 0, of: MockData.oneWeekAgo)!,
                            to: calendar.date(bySettingHour: 14, minute: 0, second: 0, of: MockData.oneWeekAgo)!
                        )
                    ],
                    id: "1",
                    name: "Anderson Structure",
                    spotsAvailable: 50
                )
            )
        )
    )

    static let secondaryMock = Mock<ProjectInterTestMocks.Query>(
        system: .init(
            parkingSystem: .init(
                parkingStructure: .init(
                    address: "200 W Sycamore Ave, Orange, CA 92866 United States",
                    capacity: 150,
                    historicalAverages: [
                        .init(
                            averageSpotsAvailable: 140,
                            from: calendar.date(bySettingHour: 8, minute: 0, second: 0, of: MockData.oneWeekAgo)!,
                            to: calendar.date(bySettingHour: 10, minute: 0, second: 0, of: MockData.oneWeekAgo)!
                        ),
                        .init(
                            averageSpotsAvailable: 110,
                            from: calendar.date(bySettingHour: 10, minute: 0, second: 0, of: MockData.oneWeekAgo)!,
                            to: calendar.date(bySettingHour: 12, minute: 0, second: 0, of: MockData.oneWeekAgo)!
                        ),
                        .init(
                            averageSpotsAvailable: 100,
                            from: calendar.date(bySettingHour: 12, minute: 0, second: 0, of: MockData.oneWeekAgo)!,
                            to: calendar.date(bySettingHour: 14, minute: 0, second: 0, of: MockData.oneWeekAgo)!
                        ),
                        .init(
                            averageSpotsAvailable: 95,
                            from: calendar.date(bySettingHour: 14, minute: 0, second: 0, of: MockData.oneWeekAgo)!,
                            to: calendar.date(bySettingHour: 16, minute: 0, second: 0, of: MockData.oneWeekAgo)!
                        )
                    ],
                    id: "2",
                    name: "Barrera",
                    spotsAvailable: 100
                )
            )
        )
    )

    static let tertiaryMock = Mock<ProjectInterTestMocks.Query>(
        system: .init(
            parkingSystem: .init(
                parkingStructure: .init(
                    address: "200 W Sycamore Ave, Orange, CA 92866 United States",
                    capacity: 100,
                    id: "2",
                    name: "Barrera",
                    spotsAvailable: 100
                )
            )
        )
    )
}

func constructViewModelWithReferenceDate(_ date: Date) -> ParkingStructureInfoContentView.ViewModel {
    return ParkingStructureInfoContentView.ViewModel(referenceDate: date)
}

class ParkingStructureInfoContentViewModelDataTests {
    @Test("injectUpdate maps structure data and averages") func injectUpdateMapsData() async {
        let viewModel = ParkingStructureInfoContentView.ViewModel()
        let data = await GetParkingStructureInfoDataQuery.Data.from(MockData.defaultMock)

        await viewModel.injectUpdate(.success(data))

        #expect(viewModel.capacity == 100)
        #expect(viewModel.spotsAvailable == 50)
        #expect(viewModel.name == "Anderson Structure")
        #expect(viewModel.address == "300 E Walnut Ave, Orange, CA 92867 United States")

        #expect(viewModel.averages?.count == 3)
    }

    @Test("injectUpdate without a structure clears the data") func injectUpdateWithoutStructureClearsData() async {
        let viewModel = ParkingStructureInfoContentView.ViewModel(referenceDate: MockData.oneWeekAgo)
        let populatedData = await GetParkingStructureInfoDataQuery.Data.from(MockData.defaultMock)
        await viewModel.injectUpdate(.success(populatedData))

        let emptyMock = Mock<ProjectInterTestMocks.Query>(
            system: .init(
                parkingSystem: .init(
                    parkingStructure: nil
                )
            )
        )
        let emptyData = await GetParkingStructureInfoDataQuery.Data.from(emptyMock)
        await viewModel.injectUpdate(.success(emptyData))

        #expect(viewModel.capacity == nil)
        #expect(viewModel.spotsAvailable == nil)
        #expect(viewModel.name == nil)

        #expect(viewModel.averages == nil)
        #expect(viewModel.startOfCurrentTimePeriod == nil)
        #expect(viewModel.endOfCurrentTimePeriod == nil)
    }

    @Test func findAverageCorrespondingToDateReturnsCorrectAverage() {
        let now = Date()
        let viewModel = ParkingStructureInfoContentView.ViewModel()
        viewModel.averages = [
            .init(
                from: MockData.calendar.date(bySettingHour: 8, minute: 0, second: 0, of: now)!,
                to: MockData.calendar.date(bySettingHour: 10, minute: 0, second: 0, of: now)!,
                averageSpotsAvailable: 50
            ),
            .init(
                from: MockData.calendar.date(bySettingHour: 10, minute: 0, second: 0, of: now)!,
                to: MockData.calendar.date(bySettingHour: 12, minute: 0, second: 0, of: now)!,
                averageSpotsAvailable: 28
            ),
            .init(
                from: MockData.calendar.date(bySettingHour: 12, minute: 0, second: 0, of: now)!,
                to: MockData.calendar.date(bySettingHour: 14, minute: 0, second: 0, of: now)!,
                averageSpotsAvailable: 15
            )
        ]

        let dateInput = MockData.calendar.date(bySettingHour: 13, minute: 0, second: 0, of: now)!
        let result = viewModel.findAverageCorrespondingToDate(dateInput)

        #expect(result?.from == viewModel.averages![2].from)
        #expect(result?.to == viewModel.averages![2].to)
    }

    @Test func findAverageCorrespondingToDateReturnsNil() {
        let now = Date()
        let viewModel = ParkingStructureInfoContentView.ViewModel()
        viewModel.averages = [
            .init(
                from: MockData.calendar.date(bySettingHour: 8, minute: 0, second: 0, of: now)!,
                to: MockData.calendar.date(bySettingHour: 10, minute: 0, second: 0, of: now)!,
                averageSpotsAvailable: 50
            ),
            .init(
                from: MockData.calendar.date(bySettingHour: 10, minute: 0, second: 0, of: now)!,
                to: MockData.calendar.date(bySettingHour: 12, minute: 0, second: 0, of: now)!,
                averageSpotsAvailable: 28
            ),
            .init(
                from: MockData.calendar.date(bySettingHour: 12, minute: 0, second: 0, of: now)!,
                to: MockData.calendar.date(bySettingHour: 14, minute: 0, second: 0, of: now)!,
                averageSpotsAvailable: 15
            )
        ]

        let dateInput = MockData.calendar.date(bySettingHour: 20, minute: 0, second: 0, of: now)!
        let result = viewModel.findAverageCorrespondingToDate(dateInput)

        #expect(result == nil)
    }

    @Test func viewModelCorrectlyGeneratesHistoricalAverageInput() {
        let oneWeekAgo = MockData.calendar.date(byAdding: .day, value: -7, to: Date())!
        let expectedFrom = MockData.calendar.date(bySettingHour: ParkingStructureInfoContentView.ViewModel.startingHour, minute: 0, second: 0, of: oneWeekAgo)!
        let expectedTo = MockData.calendar.date(bySettingHour: ParkingStructureInfoContentView.ViewModel.endingHour, minute: 0, second: 0, of: oneWeekAgo)!

        let input = ParkingStructureInfoContentView.ViewModel.generateHistoricalAverageInput(for: oneWeekAgo)

        #expect(input?.from == expectedFrom)
        #expect(input?.to == expectedTo)
        #expect(input?.intervalMs == Int32(ParkingStructureInfoContentView.ViewModel.intervalMs))
    }

    @Test func processCurrentDayAveragesShiftsAveragesBackOneWeek() async {
        let viewModel = ParkingStructureInfoContentView.ViewModel(referenceDate: MockData.oneWeekAgo)

        // Averages generated for the current day; the processor shifts them
        // back one week to align with the chart's day-of-week axis.
        let data = await GetParkingStructureInfoDataQuery.Data.from(
            Mock<ProjectInterTestMocks.Query>(
                system: .init(
                    parkingSystem: .init(
                        parkingStructure: .init(
                            address: "300 E Walnut Ave, Orange, CA 92867 United States",
                            capacity: 100,
                            historicalAverages: [
                                .init(
                                    averageSpotsAvailable: 80,
                                    from: MockData.calendar.date(bySettingHour: 8, minute: 0, second: 0, of: Date())!,
                                    to: MockData.calendar.date(bySettingHour: 10, minute: 0, second: 0, of: Date())!
                                ),
                                .init(
                                    averageSpotsAvailable: 67,
                                    from: MockData.calendar.date(bySettingHour: 10, minute: 0, second: 0, of: Date())!,
                                    to: MockData.calendar.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!
                                ),
                                .init(
                                    averageSpotsAvailable: 55,
                                    from: MockData.calendar.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!,
                                    to: MockData.calendar.date(bySettingHour: 14, minute: 0, second: 0, of: Date())!
                                )
                            ],
                            id: "1",
                            name: "Anderson Structure",
                            spotsAvailable: 50
                        )
                    )
                )
            )
        )

        await viewModel.processCurrentDayAverages(data)

        let currentDayAverages = viewModel.currentDayAverages
        #expect(currentDayAverages?.count == 3)

        let first = currentDayAverages?[0]
        #expect(first?.averageSpotsAvailableRounded == 80)
        #expect(first?.from == MockData.calendar.date(byAdding: .day, value: -7, to: MockData.calendar.date(bySettingHour: 8, minute: 0, second: 0, of: Date())!))
        #expect(first?.to == MockData.calendar.date(byAdding: .day, value: -7, to: MockData.calendar.date(bySettingHour: 10, minute: 0, second: 0, of: Date())!))
    }
}

class ParkingStructureInfoContentParkingInsightTests {
    @Test func viewModelCorrectlyGeneratesParkingInsightIfLessSpotsAvailable() async {
        let viewModel = ParkingStructureInfoContentView.ViewModel(
            referenceDate: MockData.calendar.date(bySettingHour: 8, minute: 5, second: 0, of: Date())!
        )
        let data = await GetParkingStructureInfoDataQuery.Data.from(MockData.defaultMock)
        await viewModel.injectUpdate(.success(data))

        #expect(viewModel.parkingInsight?.contains("Anderson Structure") == true)
        #expect(viewModel.parkingInsight?.contains("150%") == true)
        #expect(viewModel.parkingInsight?.contains("more") == true)
    }

    @Test func viewModelCorrectlyGeneratesParkingInsightIfMoreSpotsAvailable() async {
        let viewModel = ParkingStructureInfoContentView.ViewModel(
            referenceDate: MockData.calendar.date(bySettingHour: 15, minute: 0, second: 0, of: Date())!
        )
        let data = await GetParkingStructureInfoDataQuery.Data.from(MockData.secondaryMock)
        await viewModel.injectUpdate(.success(data))

        #expect(viewModel.parkingInsight?.contains("Barrera") == true)
        #expect(viewModel.parkingInsight?.contains("9%") == true)
        #expect(viewModel.parkingInsight?.contains("less") == true)
    }

    @Test func viewModelCorrectlyGeneratesParkingInsightIfSameNumberOfSpotsAvailable() async {
        let viewModel = ParkingStructureInfoContentView.ViewModel(
            referenceDate: MockData.calendar.date(bySettingHour: 13, minute: 0, second: 0, of: Date())!
        )
        let data = await GetParkingStructureInfoDataQuery.Data.from(MockData.secondaryMock)
        await viewModel.injectUpdate(.success(data))

        #expect(viewModel.parkingInsight == "Barrera was also around this filled last week.")
    }

    @Test func viewModelCorrectlyGeneratesParkingInsightIfParkingLotEmpty() async {
        let viewModel = ParkingStructureInfoContentView.ViewModel(
            referenceDate: MockData.calendar.date(bySettingHour: 13, minute: 0, second: 0, of: Date())!
        )
        let data = await GetParkingStructureInfoDataQuery.Data.from(MockData.tertiaryMock)
        await viewModel.injectUpdate(.success(data))

        #expect(viewModel.parkingInsight == nil)
    }
}
