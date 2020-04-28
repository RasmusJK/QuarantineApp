//
//  QuarantineAppUITests.swift
//  QuarantineAppUITests
//
//  Created by Roope Vaarama on 14.4.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//

import XCTest

class QuarantineAppUITests: XCTestCase {

     /*func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

     func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    */

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
    }
   
    func testInvalidLogin_alertAppears () {
        
        let app = XCUIApplication()
        app.launch()
        
        let invalid = "invalid"
        app.navigationBars["QuarantineApp.HomeView"].buttons["Auth"].tap()
        
       let userField = app.textFields["Username"]
        userField.tap()
        userField.typeText(invalid)
        
        let passField = app.secureTextFields["Password"]
        passField.tap()
        passField.typeText(invalid)
        app.buttons["Login"].tap()
        
        let elementsQuery = app.alerts["Login error"].scrollViews.otherElements
       let errorText =  elementsQuery.staticTexts["There is no user record corresponding to this identifier. The user may have been deleted."]
        XCTAssertTrue(errorText.exists)
        
        elementsQuery.buttons["OK"].tap()
       
    }
    

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
