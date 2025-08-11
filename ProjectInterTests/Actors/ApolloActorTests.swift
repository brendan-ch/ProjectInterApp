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
    
    @Test func getStreamYieldsExpectedValuesFromApolloClient() async {
        
    }
    
    @Test func getStreamYieldsNoDataErrorFromApolloClient() async {
        
    }
    
    @Test func getStreamYieldsOtherApolloErrorFromApolloClient() async {
        
    }
    
    @Test func removeStreamRemovesExistingStreamIfExists() async {
        
    }
    
    @Test func removeStreamReturnsNilIfNoStreamExists() async {
        
    }
}
