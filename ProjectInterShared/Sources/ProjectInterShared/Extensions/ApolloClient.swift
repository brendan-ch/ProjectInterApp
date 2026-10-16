//
//  ApolloClient.swift
//  ProjectInterShared
//
//  Created by Brendan Chen on 2025.10.03.
//

import Apollo
import ApolloAPI

extension ApolloClient {
    public static var shared: ApolloClient { ApolloClient(url: .apiBaseUrl) }

    /// Continuously polls the passed query, yielding results until the
    /// consuming task is cancelled.
    public func getStream<Query: GraphQLQuery>(
        _ query: Query,
        sleepDuration: Duration = .seconds(5)
    ) -> AsyncStream<Result<Query.Data, any Swift.Error>>
    where Query.ResponseFormat == SingleResponseFormat {
        let stream = AsyncStream<Result<Query.Data, any Swift.Error>> { continuation in
            let task = Task {
                while !Task.isCancelled {
                    let result = await fetchResult(query)
                    continuation.yield(result)

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

    private func fetchResult<Query: GraphQLQuery>(
        _ query: Query
    ) async -> Result<Query.Data, any Swift.Error>
    where Query.ResponseFormat == SingleResponseFormat {
        do {
            let response = try await fetch(query: query, cachePolicy: .networkOnly)
            if let data = response.data {
                return .success(data)
            }
            return .failure(GraphQLConstructableError.dataNotAvailable)
        } catch {
            return .failure(error)
        }
    }
}
