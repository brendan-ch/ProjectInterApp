//
//  NetworkViewProtocol.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.04.18.
//

import SwiftUI
import Apollo
import ApolloAPI

protocol NetworkView: View {
    associatedtype NetworkArguments
    associatedtype ViewModelType: GraphQLProcessable & Clearable & GraphQLQueryConstructable
    where ViewModelType.NetworkArguments == NetworkArguments,
          ViewModelType.GraphQLQueryType.ResponseFormat == SingleResponseFormat

    /// View-local loading state; transitions per stream result.
    var dataInitState: InitializationState { get nonmutating set }

    /// View-owned task consuming the polling stream.
    var updateTask: Task<Void, Error>? { get nonmutating set }

    var viewModel: ViewModelType { get }

    var networkArguments: NetworkArguments? { get }
}

extension NetworkView {
    /// Clears existing data, builds the query from the view's
    /// ``NetworkView/networkArguments``, and starts consuming a polling
    /// stream from the shared Apollo client. Each stream result updates
    /// ``NetworkView/dataInitState`` and is applied to the view model.
    @MainActor
    func restartDataUpdates() {
        stopDataUpdates()

        guard let networkArguments else { return }

        let query = ViewModelType.convertNetworkArgumentsIntoQuery(networkArguments)

        viewModel.clearData()
        dataInitState = .initializing

        let stream = ApolloClient.shared.getStream(query)
        updateTask = Task {
            for await result in stream {
                dataInitState = (try? result.get()) != nil ? .succeeded : .failed
                await viewModel.injectUpdate(result)
            }
        }
    }

    @MainActor
    func stopDataUpdates() {
        updateTask?.cancel()
        updateTask = nil
    }
}
