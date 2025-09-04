//
//  NetworkDataModel.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.09.03.
//

import ApolloAPI

class NetworkDataModel<NetworkArguments, GraphQLQueryType: GraphQLQuery>: NetworkDataModelProtocol {
    private(set) var dataInitState: InitializationState = .notInitialized
    private var dataRefreshLoopTask: Task<Void, Error>?
    var apolloNetworkModel: ApolloNetworkModel?
    
    required init(apolloNetworkModel: ApolloNetworkModel? = nil) {
        self.apolloNetworkModel = apolloNetworkModel
    }
    
    /// Initialize the model with a custom loading state and no network model.
    /// Useful for building placeholders or simulation during tests.
    init(dataInitState: InitializationState) {
        self.dataInitState = dataInitState
    }
    
    @MainActor
    private func setDataInitState(_ newState: InitializationState) {
        if newState == .initializing && (dataInitState == .notInitialized || dataInitState == .failed) {
            self.dataInitState = newState
        } else if (newState == .succeeded || newState == .failed) && dataInitState == .initializing {
            self.dataInitState = newState
        }
    }

    func startRefreshingData(arguments: NetworkArguments, sleepDuration: Duration = .seconds(5)) {
        if dataRefreshLoopTask != nil {
            Loggers.shared.networkingLogger.warning("Data refresh already active for \(type(of: self))")
            return
        }
        
        guard let query = convertNetworkArgumentsIntoQuery(arguments) else {
            Loggers.shared.networkingLogger.error("No query generated for \(type(of: self))")
            return
        }

        Loggers.shared.networkingLogger.notice("Starting data refresh for \(type(of: self))")
        
        guard let stream = apolloNetworkModel?.getStream(query, sleepDuration: sleepDuration) else {
            return
        }
        dataRefreshLoopTask = Task {
            await setDataInitState(.initializing)

            for try await result in stream {
                switch result {
                case .failure:
                    await setDataInitState(.failed)
                case .success:
                    await setDataInitState(.succeeded)
                }
                
                await processRefreshDataResult(result)
            }
        }
    }

    func stopRefreshingData() {
        Loggers.shared.networkingLogger.notice("Stopping data refresh for \(type(of: self))")
        dataRefreshLoopTask?.cancel()
        dataRefreshLoopTask = nil
    }
    
    func refreshDataOnce(arguments: NetworkArguments) async {
        await setDataInitState(.initializing)
        
        // Spawn a one-off task to refresh the data
        guard let query = convertNetworkArgumentsIntoQuery(arguments) else {
            Loggers.shared.networkingLogger.error("No query generated for \(type(of: self))")
            return
        }
        
        guard let apolloNetworkModel = apolloNetworkModel else {
            await setDataInitState(.failed)
            Loggers.shared.networkingLogger.warning("No network model provided for \(type(of: self)); skipping data refresh")
            return
        }
        Loggers.shared.networkingLogger.notice("Refreshing data for \(type(of: self))")
        do {
            let result = try await apolloNetworkModel.fetchOnce(query)
            if let data = result.data {
                await setDataInitState(.succeeded)
                await processRefreshDataResult(.success(data))
            }
        } catch {
            await setDataInitState(.failed)
            await processRefreshDataResult(.failure(error))
        }
    }
    
    class Builder<DataModel: NetworkDataModel> {
        var model = DataModel()
        
        func withDataInitState(_ state: InitializationState) -> DataModel.Builder<DataModel> {
            model.dataInitState = .initializing
            return self
        }
        
        func build() -> NetworkDataModel {
            return model
        }
    }
}
