//
//  ApolloActor.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.08.11.
//

import Foundation
import Apollo
import ApolloAPI
import ProjectInterLogging

class ApolloNetworkModel {
    private(set) var client: ApolloClient
    
    init(client: ApolloClient) {
        self.client = client
    }

    /// Replace the underlying Apollo client, e.g. after the server URL changes.
    func reconfigure(with newClient: ApolloClient) {
        self.client = newClient
    }
    
    func getStream<Query: GraphQLQuery>(
        // Will need to wait for Apollo 2.0.0 migration to resolve non-sendable type error
        _ query: Query,
        sleepDuration: Duration = .seconds(5)
    ) -> AsyncStream<Result<Query.Data, Error>> {
        let stream = AsyncStream<Result<Query.Data, Error>> { continuation in
            let task = Task {
                while !Task.isCancelled {
                    do {
                        let result = try await self.fetchOnce(query)
                        if let data = result.data {
                            continuation.yield(.success(data))
                        }
                    } catch {
                        Loggers.shared.networkingLogger.error("\(error.localizedDescription)")
                        continuation.yield(.failure(error))
                    }
                    
                    try? await Task.sleep(for: sleepDuration)
                }
                continuation.finish()
            }
            
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
        
        return stream
    }
    
    func fetchOnce<Query: GraphQLQuery>(_ query: Query) async throws -> GraphQLResponse<Query> {
        return try await withCheckedThrowingContinuation { continuation in
            var continuationIsActive = true

            client.fetch(query: query) { result in
                defer {
                    continuationIsActive = false
                }
                
                if !continuationIsActive {
                    return
                }

                // ensure this is only called once
                continuation.resume(with: result)
            }
        }
    }
    
    func mutateOnce<Mutation: GraphQLMutation>(_ mutation: Mutation) async throws -> GraphQLResponse<Mutation> {
        return try await withCheckedThrowingContinuation { continuation in
            var continuationIsActive = true
            
            client.perform(mutation: mutation) { result in
                defer {
                    continuationIsActive = false
                }
                
                if !continuationIsActive {
                    return
                }
               
                continuation.resume(with: result)
            }
        }
    }
}

extension ApolloNetworkModel {
    static let shared = ApolloNetworkModel(client: ApolloClient.shared)
}
