//
//  QuarantineAppUITests.swift
//  QuarantineAppUITests
//
//  Created by Roope Vaarama on 14.4.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//

import XCTest

class QuarantineAppUITests: XCTestCase {


    func setUpWithError() throws {

        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

     func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


    func testCommunity() {
        
        
    }
    func testHome(){
        



    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app/*@START_MENU_TOKEN@*/.buttons["Movies"]/*[[".segmentedControls.buttons[\"Movies\"]",".buttons[\"Movies\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Shows"]/*[[".segmentedControls.buttons[\"Shows\"]",".buttons[\"Shows\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Games"]/*[[".segmentedControls.buttons[\"Games\"]",".buttons[\"Games\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Streams"]/*[[".segmentedControls.buttons[\"Streams\"]",".buttons[\"Streams\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
                
        
    
        
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
        passField.typeText("invalid")
        app.buttons["Login"].tap()
        
        let elementsQuery = app.alerts["Login error"].scrollViews.otherElements
       let errorText =  elementsQuery.staticTexts["There is no user record corresponding to this identifier. The user may have been deleted."]
        XCTAssertTrue(errorText.exists)
        
        elementsQuery.buttons["OK"].tap()
       
    }
    func testJokes(){
    
        
        let app = XCUIApplication()
        app.launch()
        app.navigationBars["QuarantineApp.HomeView"].buttons["line.horizontal.3"].tap()
        app.tables/*@START_MENU_TOKEN@*/.cells.containing(.image, identifier:"trash")/*[[".cells.containing(.staticText, identifier:\"Jokes\")",".cells.containing(.image, identifier:\"trash\")"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.children(matching: .other).element(boundBy: 0).tap()
        app.buttons["Next Joke"].tap()
     let jokeText = app.staticTexts["Jokes"]
        XCTAssert(jokeText.exists)
        app.navigationBars.buttons["Back"].tap()
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
}
