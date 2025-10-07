//
//  UserDefaultsMigrator.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.10.06.
//

import Foundation

struct UserDefaultsMigrator {
    let standardUserDefaults: UserDefaults
    let sharedUserDefaults: UserDefaults?
    
    // MARK: - Interface
    init(
        standardUserDefaults: UserDefaults = .standard,
        sharedUserDefaults: UserDefaults? = .group
    ) {
        self.standardUserDefaults = standardUserDefaults
        self.sharedUserDefaults = sharedUserDefaults
    }

    func run() {
        migrateSelectedSystemIdFromInitialIdFlag()
        migrateSelectedSystemId()
    }
    
    // MARK: - Migrations
    private func migrateSelectedSystemId() {
        if let systemId = standardUserDefaults.string(forKey: UserDefaults.selectedSystemIdKey) {
            sharedUserDefaults?.setValue(systemId, forKey: UserDefaults.selectedSystemIdKey)
        }
        standardUserDefaults.removeObject(forKey: UserDefaults.selectedSystemIdKey)
    }
    
    private func migrateSelectedSystemIdFromInitialIdFlag() {
        if let systemId = standardUserDefaults.string(forKey: UserDefaults.initialSystemIdKey) {
            sharedUserDefaults?.setValue(systemId, forKey: UserDefaults.selectedSystemIdKey)
        }
        standardUserDefaults.removeObject(forKey: UserDefaults.initialSystemIdKey)
    }
}
