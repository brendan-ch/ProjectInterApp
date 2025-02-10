//
//  GlobalNotificationSchedulingModelTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.02.09.
//

import Testing
@testable import ProjectInter
import ApolloTestSupport
import ProjectInterTestMocks

class GlobalNotificationSchedulingModelTests {
    let successfulScheduleNotificationResponse =  Mock<Mutation>(
        scheduleNotification: .init(
            data: .init(
                deviceId: "1",
                shuttleId: "1",
                stopId: "1"
            ),
            message: "Successfully performed operation",
            success: true
        )
    )

    let failedScheduleNotificationResponse = Mock<Mutation>(
        cancelNotification: .init(
            data: nil,
            message: "Failed to perform operation",
            success: false
        )
    )
    
    let arguments = NotificationNetworkArguments(
        deviceId: "1",
        shuttleId: "1",
        stopId: "1"
    )
    
    func generateSuccessfulResponseApolloClientMock() -> MockApolloClient {
        let mockApolloClient = MockApolloClient()
        mockApolloClient.mutationMock = successfulScheduleNotificationResponse
        
        return mockApolloClient
    }
    
    func generateFailedResponseApolloClientMock() -> MockApolloClient {
        let mockApolloClient = MockApolloClient()
        mockApolloClient.mutationMock = failedScheduleNotificationResponse
        
        return mockApolloClient
    }
    
    @Test func scheduleNotificationSchedulesNotificationWithApollo() async throws {
        let mockApolloClient = generateSuccessfulResponseApolloClientMock()
        let model = GlobalNotificationSchedulingModel(apolloClient: mockApolloClient)
        
        await #expect(throws: Never.self) {
            try await model.scheduleNotification(arguments)
        }
    }
    
    @Test func scheduleNotificationThrowsErrorIfFailing() async {
        let mockApolloClient = generateFailedResponseApolloClientMock()
        let model = GlobalNotificationSchedulingModel(apolloClient: mockApolloClient)
        
        await #expect(throws: NotificationSchedulingFailedError.operationFailed) {
            try await model.scheduleNotification(arguments)
        }
    }
    
    @Test func removeNotificationRemovesNotificationWithApollo() async {
        let mockApolloClient = generateSuccessfulResponseApolloClientMock()
        let model = GlobalNotificationSchedulingModel(apolloClient: mockApolloClient)
        
        await #expect(throws: Never.self) {
            try await model.removeNotification(arguments)
        }
    }
    
    @Test func removeNotificationThrowsErrorIfFailing() async {
        let mockApolloClient = generateSuccessfulResponseApolloClientMock()
        let model = GlobalNotificationSchedulingModel(apolloClient: mockApolloClient)
        
        await #expect(throws: NotificationSchedulingFailedError.operationFailed) {
            try await model.removeNotification(arguments)
        }
    }
}
