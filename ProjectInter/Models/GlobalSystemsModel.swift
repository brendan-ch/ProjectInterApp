//
//  GlobalSystemsModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.22.
//

import Foundation
import Apollo
import ProjectInterOperations
import ProjectInterLogging

// MARK: - Models

/// Represents a single system available from the server.
struct System: Equatable, Identifiable {
    var name: String
    var id: String
    var initialRegion: InitialRegion?
}


// MARK: - Network arguments

struct GlobalDataModelNetworkArguments {
    
}

@Observable
class GlobalSystemsModel: NetworkDataModel<GlobalDataModelNetworkArguments, GetAllSystemsQuery>, PlaceholderBuildable {
    typealias NetworkArguments = GlobalDataModelNetworkArguments
    
    private(set) var userDefaults: UserDefaults? = .group
    
    var systems: [System] = []
    
    /// System ID which depends on UserDefaults. Is available significantly
    /// earlier than `selectedSystem`, which requires a network round-trip.
    private(set) var locallyPersistedSelectedSystemId: String? {
        get {
            access(keyPath: \.locallyPersistedSelectedSystemId)
            return userDefaults?.string(forKey: UserDefaults.selectedSystemIdKey) ?? ""
        }
        set {
            withMutation(keyPath: \.locallyPersistedSelectedSystemId) {
                userDefaults?.setValue(newValue, forKey: UserDefaults.selectedSystemIdKey)
            }
            Loggers.shared.globalStateEventsLogger.notice("Selected system ID changed to: \(self.locallyPersistedSelectedSystemId ?? "nil")")
        }
    }
    
    /// The selected system based on the selected system ID.
    /// Depends on the `systems` array to be populated.
    var selectedSystem: System? {
        systems.first { $0.id == locallyPersistedSelectedSystemId }
    }
    
    required init(apolloNetworkModel: ApolloNetworkModel? = nil) {
        super.init(apolloNetworkModel: apolloNetworkModel)
        self.userDefaults = UserDefaults.group
    }

    init(
        apolloNetworkModel: ApolloNetworkModel? = nil,
        userDefaults: UserDefaults? = UserDefaults.group
    ) {
        super.init(apolloNetworkModel: apolloNetworkModel)
        self.userDefaults = userDefaults
    }
    
    required init(dataInitState: InitializationState) {
        super.init(dataInitState: dataInitState)
    }
    
    override func convertNetworkArgumentsIntoQuery(_ arguments: GlobalDataModelNetworkArguments) -> GetAllSystemsQuery {
        return GetAllSystemsQuery()
    }
    
    override func processRefreshDataResult(_ result: Result<GetAllSystemsQuery.Data, any Error>) {
        switch result {
        case .success(let data):
            self.systems = data.systems.map { system in
                let initialRegion: InitialRegion? = system.initialRegion.map { region in
                    InitialRegion(
                        topLeft: RawCoordinates(
                            latitude: region.topLeft.latitude,
                            longitude: region.topLeft.longitude
                        ),
                        bottomRight: RawCoordinates(
                            latitude: region.bottomRight.latitude,
                            longitude: region.bottomRight.longitude
                        )
                    )
                }
                return System(name: system.name, id: system.id, initialRegion: initialRegion)
            }
        case .failure(let error):
            Loggers.shared.networkingLogger.error("Error fetching data: \(error)")
        }
    }

    func selectSystemId(_ id: String) {
        locallyPersistedSelectedSystemId = id
    }
    
    static func buildPlaceholder() -> Self {
        let model = Self(dataInitState: .succeeded)
        model.systems = [
            System(
                name: "Chapman University",
                id: "1",
                initialRegion: InitialRegion(
                    topLeft: RawCoordinates(latitude: 33.800, longitude: -117.900),
                    bottomRight: RawCoordinates(latitude: 33.780, longitude: -117.845)
                )
            ),
            System(name: "City of Monterey Park", id: "2")
        ]

        return model
    }
}
