//
//  SetupStateModelTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.03.06.
//

import Testing
@testable import ProjectInter
import Foundation
import ProjectInterShared

class SetupStateModelTests {
    @Test func initialStateIsCorrectIfSetupNotComplete() {
        let userDefaults = MockUserDefaults()
        userDefaults.setValue(true, forKey: UserDefaults.setupCompletedKey)
        
        let model = SetupStateModel(userDefaults: userDefaults)
        
        #expect(model.setupCompleted == true)
    }
    
    @Test func initialStateIsCorrectIfSetupComplete() {
        let userDefaults = MockUserDefaults()
        userDefaults.setValue(false, forKey: UserDefaults.setupCompletedKey)

        let model = SetupStateModel(userDefaults: userDefaults)
        
        #expect(model.setupCompleted == false)
    }

    @Test func completeSetupSetsUserDefaultsAndUpdatesState() {
        let userDefaults = MockUserDefaults()
        userDefaults.setValue(false, forKey: UserDefaults.setupCompletedKey)

        let model = SetupStateModel(userDefaults: userDefaults)
        model.completeSetup()
        
        #expect(userDefaults.lastKeySetTo == UserDefaults.setupCompletedKey)
        #expect(userDefaults.lastValueSetTo as? Bool == true)
        #expect(model.setupCompleted == true)
    }
}
