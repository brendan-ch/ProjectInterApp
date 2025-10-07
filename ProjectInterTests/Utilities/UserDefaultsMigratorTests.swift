//
//  UserDefaultsMigratorTests.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.10.06.
//

import Testing
@testable import ProjectInter
import Foundation

class UserDefaultsMigratorTests {
    private func generateUserDefaults() -> (MockUserDefaults, MockUserDefaults) {
        return (MockUserDefaults(), MockUserDefaults())
    }
    
    @Test func testMigrateSelectedSystemIdMovesSystemId() async throws {
        let (standard, shared) = generateUserDefaults()
        standard.setValue("5", forKey: UserDefaults.selectedSystemIdKey)
        
        UserDefaultsMigrator(
            standardUserDefaults: standard,
            sharedUserDefaults: shared
        ).run()
        
        #expect(shared.string(forKey: UserDefaults.selectedSystemIdKey) == "5")
        #expect(standard.string(forKey: UserDefaults.selectedSystemIdKey) == nil)
    }
    
    @Test func testMigrateSelectedSystemIdWhenNil() async throws {
        
    }
}
