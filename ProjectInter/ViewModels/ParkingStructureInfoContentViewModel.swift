//
//  ParkingStructureInfoContentViewModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.08.06.
//

import Foundation
import Apollo
import ProjectInterOperations

// MARK: - Models

struct ParkingAveragePerTimePeriod {
    let from: Date
    let to: Date
    let averageSpotsAvailable: Float
    var averageSpotsAvailableRounded: Int {
        Int(self.averageSpotsAvailable.rounded())
    }
}

extension ParkingAveragePerTimePeriod {
    init(_ average: GetParkingStructureInfoDataQuery.Data.System.ParkingSystem.ParkingStructure.HistoricalAverage) {
        from = average.from
        to = average.to
        averageSpotsAvailable = Float(average.averageSpotsAvailable)
    }
}

struct ParkingStructureNetworkingArguments {
    let systemId: String
    let parkingStructureId: String
}

// MARK: - View model implementation

class ParkingStructureInfoContentViewModel: NetworkDataModelProtocol {
    // MARK: Constants
    static let startingHour = 8
    static let endingHour = 20
    static let intervalMs = 1000 * 60 * 60 * 2
    
    private let calendar = Calendar.current

    // MARK: Published properties
    
    @Published var name: String?
    @Published var capacity: Int?
    @Published var spotsAvailable: Int?
    @Published var address: String?
    
    @Published var averages: [ParkingAveragePerTimePeriod]?
    
    @Published var startOfCurrentTimePeriod: Date?
    @Published var endOfCurrentTimePeriod: Date?
    
    @Published var dataInitState: InitializationState = .notInitialized
    
    
    // MARK: Conformance to protocol

    typealias NetworkArguments = ParkingStructureNetworkingArguments
    
    var dataRefreshLoopTask: Task<Void, any Error>?
    
    var apolloNetworkModel: ApolloNetworkModel?

    required init(apolloNetworkModel: ApolloNetworkModel? = nil) {
        self.apolloNetworkModel = apolloNetworkModel
    }

    private func setStartAndEndPeriodForCurrentCorrespondingAverage() {
        let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
        guard let average = findAverageCorrespondingToDate(oneWeekAgo) else {
            return
        }

        let numSecondsDiff: TimeInterval = 1
        startOfCurrentTimePeriod = average.from - numSecondsDiff
        endOfCurrentTimePeriod = average.to
    }
    
    func findAverageCorrespondingToDate(_ date: Date) -> ParkingAveragePerTimePeriod? {
        guard let averages = averages else {
            return nil
        }
        
        for average in averages {
            if average.from <= date && average.to >= date {
                return average
            }
        }

        return nil
    }
    
    func generateHistoricalAverageInput() -> HistoricalParkingAverageQueryInput {
        let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
        
        let from = calendar.date(bySettingHour: ParkingStructureInfoContentViewModel.startingHour, minute: 0, second: 0, of: oneWeekAgo)!
        let to = calendar.date(bySettingHour: ParkingStructureInfoContentViewModel.endingHour, minute: 0, second: 0, of: oneWeekAgo)!
        
        let historicalAverageInput = HistoricalParkingAverageQueryInput(
            from: from,
            to: to,
            // Every 2 hours
            intervalMs: ParkingStructureInfoContentViewModel.intervalMs
        )
        return historicalAverageInput
    }
    
    func convertNetworkArgumentsIntoQuery(_ arguments: NetworkArguments) -> GetParkingStructureInfoDataQuery {
        let historicalAverageInput = generateHistoricalAverageInput()
        return GetParkingStructureInfoDataQuery(
            systemId: arguments.systemId,
            parkingStructureId: arguments.parkingStructureId,
            historicalAveragesInput: historicalAverageInput)
    }
    
    func processRefreshDataResult(_ result: Result<GetParkingStructureInfoDataQuery.Data, any Error>) {
        switch result {
        case .failure(let error):
            Loggers.shared.networkingLogger.log("Failed to fetch parking structure info: \(error)")
        case .success(let result):
            guard let parkingStructure = result.system?.parkingSystem?.parkingStructure else {
                clearAllData()
                return
            }
            
            name = parkingStructure.name
            capacity = parkingStructure.capacity
            spotsAvailable = parkingStructure.spotsAvailable
            address = parkingStructure.address
            
            guard let averagesFromNetwork = parkingStructure.historicalAverages else {
                clearHistoricalData()
                return
            }
            
            averages = averagesFromNetwork.map(ParkingAveragePerTimePeriod.init)
            setStartAndEndPeriodForCurrentCorrespondingAverage()
        }
    }
    
    private func clearAllData() {
        name = nil
        capacity = nil
        spotsAvailable = nil
        
        clearHistoricalData()
    }
    
    private func clearHistoricalData() {
        averages = nil
        startOfCurrentTimePeriod = nil
        endOfCurrentTimePeriod = nil
    }
    
    private var percentageEncodedAddress: String? {
        guard let address else { return nil }
        return address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    
    /// Get the Apple Maps URL of the parking structure, if exists.
    /// See [how to generate Maps links](https://developer.apple.com/library/archive/featuredarticles/iPhoneURLScheme_Reference/MapLinks/MapLinks.html).
    func getAppleMapsUrlForParkingStructure() -> URL? {
        guard let percentageEncodedAddress = percentageEncodedAddress else { return nil }
        return URL(string: "https://maps.apple.com/?address=\(percentageEncodedAddress)")
    }
    
    func getGoogleMapsUrlForParkingStructure() -> URL? {
        guard let percentageEncodedAddress = percentageEncodedAddress else { return nil }
        return URL(string: "https://www.google.com/maps?q=\(percentageEncodedAddress)")
    }
}
