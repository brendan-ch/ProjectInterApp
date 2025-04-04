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
    let successfulNotificationResponse = Mock<NotificationResponse>(
        data: .init(
            deviceId: "1",
            shuttleId: "1",
            stopId: "1"
        ),
        message: "Successfully performed operation",
        success: true
    )
    
    let failedNotificationResponse = Mock<NotificationResponse>(
        data: nil,
        message: "Failed to perform operation",
        success: false
    )
    
    let arguments = NotificationNetworkArguments(
        deviceId: "1",
        shuttleId: "1",
        stopId: "1",
        secondsThreshold: 240
    )
    
    @Test func scheduleNotificationSchedulesNotificationWithApollo() async throws {
        let successfulScheduleNotificationResponse =  Mock<Mutation>(
            scheduleNotification: successfulNotificationResponse
        )

        let mockApolloClient = MockApolloClient()
        mockApolloClient.mutationMock = successfulScheduleNotificationResponse
        let model = GlobalNotificationSchedulingModel(apolloClient: mockApolloClient)
        
        await #expect(throws: Never.self) {
            try await model.scheduleNotification(arguments)
        }
    }
    
    @Test func scheduleNotificationThrowsErrorIfFailing() async {
        let failedScheduleNotificationResponse = Mock<Mutation>(
            scheduleNotification: failedNotificationResponse
        )
        
        let mockApolloClient = MockApolloClient()
        mockApolloClient.mutationMock = failedScheduleNotificationResponse
        let model = GlobalNotificationSchedulingModel(apolloClient: mockApolloClient)
        
        await #expect(throws: NotificationSchedulingFailedError.operationFailed) {
            try await model.scheduleNotification(arguments)
        }
    }
    
    @Test func cancelNotificationRemovesNotificationWithApollo() async {
        let successfulCancelNotificationResponse = Mock<Mutation>(
            cancelNotification: successfulNotificationResponse
        )
        
        let mockApolloClient = MockApolloClient()
        mockApolloClient.mutationMock = successfulCancelNotificationResponse
        let model = GlobalNotificationSchedulingModel(apolloClient: mockApolloClient)
        
        await #expect(throws: Never.self) {
            try await model.cancelNotification(arguments)
        }
    }
    
    @Test func cancelNotificationThrowsErrorIfFailing() async {
        let successfulCancelNotificationResponse = Mock<Mutation>(
            cancelNotification: failedNotificationResponse
        )
        
        let mockApolloClient = MockApolloClient()
        mockApolloClient.mutationMock = successfulCancelNotificationResponse
        let model = GlobalNotificationSchedulingModel(apolloClient: mockApolloClient)
        
        await #expect(throws: NotificationSchedulingFailedError.operationFailed) {
            try await model.cancelNotification(arguments)
        }
    }
}
