//
//  InterMVP1UITests.swift
//  InterMVP1UITests
//
//  Created by Brendan Chen on 2024.12.16.
//

import XCTest
import Foundation

class BaseUITests: XCTestCase {
    var app: XCUIApplication = XCUIApplication()

    override func setUpWithError() throws {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app = XCUIApplication()
    }
    
    func skipSetupFlow() {
        // These launch arguments are automatically set in UserDefaults
        // https://sarunw.com/posts/how-to-set-userdefaults-value-with-launch-arguments/
        app.launchArguments += ["-setupCompleted", "1"]
    }
    

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func executeCallbackForEachStop(shouldExitCallbackLoop: () -> Bool) {
        let _ = app.buttons["Change stop"].waitForExistence(timeout: 20)
        app.buttons["Change stop"].tap()
        
        XCTAssert(app.collectionViews.cells.staticTexts["No stops found."].waitForNonExistence(timeout: 5))
        
        let predicate = NSPredicate(format: "identifier BEGINSWITH 'StopSelectionCollectionSearchResultItem'")
        let sectionElements = app.buttons.matching(predicate).allElementsBoundByIndex
        
        for cell in sectionElements {
            cell.tap()
            
            let shouldExit = shouldExitCallbackLoop()
            if shouldExit {
                return
            }
            
            app.buttons["Change stop"].tap()
        }
    }
    
    func checkIfRoutesExist() -> Bool {
        let routes = app.buttons.containing(NSPredicate(format: "label CONTAINS 'Route'"))
        let _ = routes.firstMatch.waitForExistence(timeout: 20)
        
        if !routes.allElementsBoundByIndex.isEmpty {
            return true
        }
        
        return false
    }
    
    func executeCallbackForEachRoute(shouldExitCallbackLoop: () -> Bool) {
        let routes = app.buttons.containing(NSPredicate(format: "label CONTAINS 'Route'"))
        for route in routes.allElementsBoundByIndex {
            route.tap()
            
            let shouldExit = shouldExitCallbackLoop()
            if shouldExit {
                return
            }
            
            let _ = app.buttons["Close"].waitForExistence(timeout: 5)
            app.buttons["Close"].tap()
        }
    }

    func attemptToSelectShuttleButton() -> Bool {
        let firstMatchExists = app.otherElements.buttons["Shuttle"].waitForExistence(timeout: 20)
        if !firstMatchExists {
            return false
        }
        
        sleep(5)
        
        app.buttons["Shuttle"].firstMatch.forceTapElement()
        let shuttleTextExists = app.staticTexts["Shuttle name"].firstMatch.waitForExistence(timeout: 5)
        if !shuttleTextExists {
            // Handle cases where the selected stop may be blocking the shuttle,
            // in which case the map should handle the correct selection the second time
            app.buttons["Shuttle"].firstMatch.forceTapElement()
        }
        
        return true
    }
}
