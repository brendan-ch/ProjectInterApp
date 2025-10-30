//
//  ApolloActorTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.08.11.
//

import Testing
@testable import ProjectInter
import ProjectInterOperations
import ProjectInterShared

class ApolloNetworkModelTests {
    @Test func getStreamYieldsExpectedValuesFromApolloClient() async throws {
        let client = MockApolloClient()
        let actor = ApolloNetworkModel(client: client)
        let query = GetSchemaVersionQuery()
        
        client.queryMock = .init(
            schemaCurrentVersion: 1,
            schemaMinVersion: 1
        )
        
        let stream = actor.getStream(
            query,
            sleepDuration: .milliseconds(250)
        )
        
        await confirmation(expectedCount: 3 ..< 5) { confirmation in
            let task = Task.detached {
                for try await result in stream {
                    let data = try result.get()
                    if data.schemaCurrentVersion == client.queryMock?.schemaCurrentVersion {
                        if data.schemaMinVersion == client.queryMock?.schemaMinVersion {
                            confirmation.confirm()
                        }
                    }
                }
            }
            
            try? await Task.sleep(for: .seconds(1))
            task.cancel()
        }
    }
    
    @Test func getStreamYieldsErrorIfErrorFromApolloClient() async {
        let client = MockApolloClient()
        let actor = ApolloNetworkModel(client: client)
        let query = GetSchemaVersionQuery()
        
        client.queryMock = nil
        
        let stream = actor.getStream(
            query,
            sleepDuration: .milliseconds(250)
        )
        
        await confirmation(expectedCount: 3 ..< 5) { confirmation in
            let task = Task.detached {
                for try await result in stream {
                    switch result {
                    case .failure:
                        confirmation.confirm()
                    default: break
                    }
                }
            }
            
            try? await Task.sleep(for: .seconds(1))
            task.cancel()
        }
    }
    
    @Test func mutateOncePerformsTheMutation() async {
        let client = MockApolloClient()
        client.mutationMock = .init(
            cancelNotification: .init(
                data: .init(
                    deviceId: "1",
                    shuttleId: "1",
                    stopId: "1"
                ),
                message: "Successfully performed operation",
                success: true
            )
        )
        let actor = ApolloNetworkModel(client: client)
        let mutation = CancelNotificationMutation(input: .init(
            deviceId: "1",
            shuttleId: "1",
            stopId: "1"
        ))
        
        await #expect(throws: Never.self) {
            try await actor.mutateOnce(mutation)
        }
    }
}
