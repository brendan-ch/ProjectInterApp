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
    let successfulScheduleNotificationResponse = Mock<ProjectInterTestMocks.NotificationResponse>(
        data: Mock<ProjectInterTestMocks.Notification>(
            deviceId: "1",
            shuttleId: "1",
            stopId: "1"
        ), message: "Successfully scheduled notification",
        success: true
    )
    
    @Test func scheduleNotificationSchedulesNotificationWithApollo() async {
        
    }
    
    @Test func removeNotificationRemovesNotificationWithApollo() async {
        
    }
}
