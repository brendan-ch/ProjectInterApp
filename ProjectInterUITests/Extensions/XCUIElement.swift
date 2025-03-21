//
//  XCUIElement.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.03.21.
//

import XCTest

// Workaround for "Failed to scroll to visible (by AX action) when tap on button"
// https://stackoverflow.com/questions/33422681/xcode-ui-test-ui-testing-failure-failed-to-scroll-to-visible-by-ax-action

extension XCUIElement {
    func forceTapElement() {
        if self.isHittable {
            self.tap()
        }
        else {
            let coordinate: XCUICoordinate = self.coordinate(withNormalizedOffset: CGVector(dx:0.5, dy:0.5))
            coordinate.tap()
        }
    }
}
