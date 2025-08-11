//
//  ApolloActorTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.08.11.
//

import Testing
@testable import ProjectInter
import ProjectInterOperations

class ApolloActorTests {
    @Test func getStreamKeyReturnsDifferentValuesBasedOnVariables() async {
        let client = MockApolloClient()
        let actor = ApolloActor(client: client)
        
        let firstSampleQuery = GetParkingStructureInfoDataQuery(
            systemId: "1",
            parkingStructureId: "1",
            historicalAveragesInput: .init(
                from: .distantPast,
                to: .distantFuture,
                intervalMs: 1000
            )
        )
        let firstStreamKey = await actor.getStreamKey(firstSampleQuery)
        let secondSampleQuery = GetParkingStructureInfoDataQuery(
            systemId: "2",
            parkingStructureId: "2",
            historicalAveragesInput: .init(
                from: .distantPast,
                to: .distantFuture,
                intervalMs: 1000
            )
        )
        let secondStreamKey = await actor.getStreamKey(secondSampleQuery)
        
        #expect(firstStreamKey != secondStreamKey)
    }
    
    @Test func getStreamGetsExistingStreamIfExists() async {
        let client = MockApolloClient()
        let actor = ApolloActor(client: client)
        
        _ = await actor.getStream(GetAllSystemsQuery())
        _ = await actor.getStream(GetAllSystemsQuery())
        
        await #expect(actor.numStreams == 1)
    }
    
    @Test func getStreamCreatesNewStreamIfDoesNotExist() async {
        let client = MockApolloClient()
        let actor = ApolloActor(client: client)
        
        _ = await actor.getStream(GetAllSystemsQuery())
        _ = await actor.getStream(GetAllStopsBySystemIdQuery(systemId: "1"))
        
        await #expect(actor.numStreams == 2)
    }
    
    @Test func getStreamYieldsExpectedValuesFromApolloClient() async throws {
        let client = MockApolloClient()
        let actor = ApolloActor(client: client)
        let query = GetSchemaVersionQuery()
        
        client.queryMock = .init(
            schemaCurrentVersion: 1,
            schemaMinVersion: 1
        )
        
        let stream = await actor.getStream(
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
    
    @Test func getStreamYieldsErrorIfNoDataFromApolloClient() async {
        let client = MockApolloClient()
        let actor = ApolloActor(client: client)
        let query = GetSchemaVersionQuery()
        
        client.queryMock = nil
        
        let stream = await actor.getStream(
            query,
            sleepDuration: .milliseconds(250)
        )
        
        await confirmation(expectedCount: 3 ..< 5) { confirmation in
            let task = Task.detached {
                for try await result in stream {
                    switch result {
                    case .failure(let error):
                        confirmation.confirm()
                    default: break
                    }
                }
            }
            
            try? await Task.sleep(for: .seconds(1))
            task.cancel()
        }
    }
    
    @Test func removeStreamRemovesExistingStreamIfExists() async {
        
    }
    
    @Test func removeStreamReturnsNilIfNoStreamExists() async {
        
    }
    
    @Test func removeStreamEndsTheStreamIfExists() async {
        
    }
}
