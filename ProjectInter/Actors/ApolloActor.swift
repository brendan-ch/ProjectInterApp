//
//  ApolloActor.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.08.11.
//

import Foundation
import Apollo
import ApolloAPI

actor ApolloActor {
    private let client: ApolloClientProtocol
    private var activeStreams: [String: Any] = [:]
    
    var numStreams: Int {
        activeStreams.count
    }
    
    init(client: ApolloClientProtocol) {
        self.client = client
    }
    
    func getStream<Query: GraphQLQuery>(
        // Will need to wait for Apollo 2.0.0 migration to resolve non-sendable type error
        _ query: Query,
        sleepDuration: Duration = .seconds(5)
    ) -> AsyncStream<Result<Query.Data, Error>> {
        let streamKey = getStreamKey(query)
        
        if let existingStream = activeStreams[streamKey] as? AsyncStream<Result<Query.Data, Error>> {
            return existingStream
        }
        
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
                Task {
                    await self.removeStream(for: query)
                }
            }
        }
        
        activeStreams[streamKey] = stream
        return stream
    }
    
    func removeStream<Query: GraphQLQuery>(for query: Query) {
        let streamKey = getStreamKey(query)
        activeStreams.removeValue(forKey: streamKey)
    }
    
    func getStreamKey<Query: GraphQLQuery>(_ query: Query) -> String {
        let streamKey = String(describing: Query.self) + (query.__variables?.description ?? "")
        return streamKey
    }
    
    private func fetchOnce<Query: GraphQLQuery>(_ query: Query) async throws -> GraphQLResult<Query.Data> {
        return try await withCheckedThrowingContinuation { continuation in
            client.fetch(query: query) { result in
                continuation.resume(with: result)
            }
        }
    }
}
