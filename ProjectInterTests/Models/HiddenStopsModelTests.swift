//
//  HiddenStopsModelTests.swift
//  ProjectInter
//
//  Created by Claude on 2026.03.29.
//

import Testing
@testable import ProjectInter
import ProjectInterShared

class HiddenStopsModelTests {
    /// A fresh UserDefaults suite for test isolation.
    private func makeTestDefaults() -> UserDefaults {
        let suiteName = "dev.bchen.Inter.HiddenStopsModelTests.\(UUID().uuidString)"
        return UserDefaults(suiteName: suiteName)!
    }

    @Test func hideAndUnhideStop() {
        let defaults = makeTestDefaults()
        let model = HiddenStopsModel(userDefaults: defaults)

        model.setStopHidden("stop1", inSystem: "sys1", hidden: true)
        #expect(model.isStopHidden("stop1", inSystem: "sys1") == true)

        model.setStopHidden("stop1", inSystem: "sys1", hidden: false)
        #expect(model.isStopHidden("stop1", inSystem: "sys1") == false)
    }

    @Test func toggleStopHidden() {
        let defaults = makeTestDefaults()
        let model = HiddenStopsModel(userDefaults: defaults)

        #expect(model.isStopHidden("stop1", inSystem: "sys1") == false)
        model.toggleStopHidden("stop1", inSystem: "sys1")
        #expect(model.isStopHidden("stop1", inSystem: "sys1") == true)
        model.toggleStopHidden("stop1", inSystem: "sys1")
        #expect(model.isStopHidden("stop1", inSystem: "sys1") == false)
    }

    @Test func hiddenStopIdsPerSystem() {
        let defaults = makeTestDefaults()
        let model = HiddenStopsModel(userDefaults: defaults)

        model.setStopHidden("stop1", inSystem: "sys1", hidden: true)
        model.setStopHidden("stop2", inSystem: "sys2", hidden: true)

        #expect(model.hiddenStopIds(forSystem: "sys1") == Set(["stop1"]))
        #expect(model.hiddenStopIds(forSystem: "sys2") == Set(["stop2"]))
        #expect(model.isStopHidden("stop1", inSystem: "sys2") == false)
    }

    @Test func persistenceAcrossInstances() {
        let defaults = makeTestDefaults()

        let model1 = HiddenStopsModel(userDefaults: defaults)
        model1.setStopHidden("stop1", inSystem: "sys1", hidden: true)

        let model2 = HiddenStopsModel(userDefaults: defaults)
        #expect(model2.isStopHidden("stop1", inSystem: "sys1") == true)
    }

    @Test func emptySystemReturnsNoHiddenStops() {
        let defaults = makeTestDefaults()
        let model = HiddenStopsModel(userDefaults: defaults)

        #expect(model.hiddenStopIds(forSystem: "nonexistent").isEmpty)
    }
}
