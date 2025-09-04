//
//  GlobalSystemsModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.22.
//

import Foundation
import Apollo
import ProjectInterOperations

// MARK: - Models

/// Represents a single system available from the server.
struct System: Equatable, Identifiable {
    var name: String
    var id: String
}


// MARK: - Network arguments

struct GlobalDataModelNetworkArguments {
    
}

@Observable
class GlobalSystemsModel: NetworkDataModel<GlobalDataModelNetworkArguments, GetAllSystemsQuery>, PlaceholderBuildable {
    typealias NetworkArguments = GlobalDataModelNetworkArguments
    
    private(set) var userDefaults: UserDefaults = .standard
    
    var systems: [System] = []
    private var selectedSystemId: String? = nil {
        didSet {
            Loggers.shared.globalStateEventsLogger.notice("Selected system ID changed to: \(self.selectedSystemId ?? "nil")")
        }
    }
    var selectedSystem: System? {
        systems.first { $0.id == selectedSystemId }
    }
    
    required init(apolloNetworkModel: ApolloNetworkModel? = nil) {
        super.init(apolloNetworkModel: apolloNetworkModel)
        self.userDefaults = UserDefaults.standard
        
        selectedSystemId = self.userDefaults.string(forKey: UserDefaults.selectedSystemIdKey)
    }

    init(
        apolloNetworkModel: ApolloNetworkModel? = nil,
        userDefaults: UserDefaults = UserDefaults.standard
    ) {
        super.init(apolloNetworkModel: apolloNetworkModel)
        self.userDefaults = userDefaults
        selectedSystemId = self.userDefaults.string(forKey: UserDefaults.selectedSystemIdKey)
    }
    
    required init(dataInitState: InitializationState) {
        super.init(dataInitState: dataInitState)
    }
    
    func convertNetworkArgumentsIntoQuery(_ arguments: GlobalDataModelNetworkArguments) -> GetAllSystemsQuery {
        return GetAllSystemsQuery()
    }
    
    func processRefreshDataResult(_ result: Result<GetAllSystemsQuery.Data, any Error>) {
        switch result {
        case .success(let data):
            self.systems = data.systems.map { system in
                System(name: system.name, id: system.id)
            }
        case .failure(let error):
            print("Error fetching data: \(error)")
        }
    }

    func selectSystemId(_ id: String) {
        selectedSystemId = id
        userDefaults.setValue(id, forKey: UserDefaults.selectedSystemIdKey)
    }
    
    static func buildPlaceholder() -> Self {
        let model = Self(dataInitState: .succeeded)
        model.systems = [
            System(name: "Chapman University", id: "1"),
            System(name: "City of Monterey Park", id: "2")
        ]
        
        return model
    }
}
