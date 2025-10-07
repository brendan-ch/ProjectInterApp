//
//  ChangelogVersionModelTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.02.18.
//

import Foundation
import Testing
@testable import ProjectInter

class AppVersionModelTests {
    func generateChangelogVersionModelWithMocks(mockActualVersion: String, mockStoredVersion: String) -> (AppVersionModel, MockBundle, MockUserDefaults) {
        let mockBundle = MockBundle()
        mockBundle.mockedVersionNumber = mockActualVersion
        let mockUserDefaults = MockUserDefaults()
        mockUserDefaults.setValue(mockStoredVersion, forKey: UserDefaults.lastViewedChangelogVersionKey)
        
        let changelogVersionModel = AppVersionModel(
            bundle: mockBundle,
            userDefaults: mockUserDefaults
        )
        
        return (changelogVersionModel, mockBundle, mockUserDefaults)
    }
    
    @Test func indicatorIsTrueIfVersionsAreDifferent() {
        let (changelogVersionModel, _, _) = generateChangelogVersionModelWithMocks(
            mockActualVersion: "0.0.2", mockStoredVersion: "0.0.1"
        )
        #expect(changelogVersionModel.shouldShowNewUpdatesIndicator)
    }
    
    @Test func indicatorIsFalseIfVersionsAreSame() {
        let (changelogVersionModel, _, _) = generateChangelogVersionModelWithMocks(
            mockActualVersion: "0.0.1", mockStoredVersion: "0.0.1"
        )
        #expect(!changelogVersionModel.shouldShowNewUpdatesIndicator)
    }
    
    @Test func updateMethodUpdatesStoredVersionAndIndicator() {
        let (changelogVersionModel, _, mockUserDefaults) = generateChangelogVersionModelWithMocks(
            mockActualVersion: "0.0.2", mockStoredVersion: "0.0.1"
        )
        changelogVersionModel.updateLastViewedChangelogVersion()
        #expect(!changelogVersionModel.shouldShowNewUpdatesIndicator)
        #expect(mockUserDefaults.lastKeySetTo == UserDefaults.lastViewedChangelogVersionKey)
        #expect(mockUserDefaults.lastValueSetTo as! String == "0.0.2")
    }
}
