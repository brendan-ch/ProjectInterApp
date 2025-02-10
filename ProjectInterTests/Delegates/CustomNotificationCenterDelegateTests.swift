//
//  CustomNotificationCenterDelegateTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.02.09.
//

import Testing
import UserNotifications
@testable import ProjectInter

class CustomNotificationCenterDelegateTests {
    func setupMockNotificationCenter() -> MockUNUserNotificationCenter {
        UNNotificationSettings.swizzleAuthorizationStatus()
        let mockNotificationCenter = MockUNUserNotificationCenter()
        mockNotificationCenter.resetAuthorization()
        return mockNotificationCenter
    }
    
    @Test func requestAuthorizationUpdateAuthorization() async {
        let mockNotificationCenter = setupMockNotificationCenter()
        
        let delegate = CustomNotificationCenterDelegate(notificationCenter: mockNotificationCenter)
        
        await delegate.requestAuthorization()
        #expect(UNNotificationSettings.fakeAuthorizationStatus == .authorized)
    }
}
