//
//  QuarantineAppUITests.swift
//  QuarantineAppUITests
//
//  Created by Roope Vaarama on 14.4.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//

import XCTest

class QuarantineAppUITests: XCTestCase {
    
    //MARK: Default tests
    /*
    func setUpWithError() throws {
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    */
    
    //MARK: Test login alerts
    func testInvalidLogin_alertAppears () { // 50/50 chance it works.
        
        let app = XCUIApplication()
        app.launch()
        
        if app.staticTexts["Login"].exists {
            let invalid = "invalid"
            //app.navigationBars["Empty core data"].buttons["Auth"].tap()
            
            let userField = app.textFields["Username"]
            userField.tap()
            userField.typeText(invalid)
            
            let passField = app.secureTextFields["Password"]
            passField.tap()
            passField.typeText(invalid) //Error here? In Simulator, 'Hardware -> Keyboard -> Connect hardware keyboard' = off
            app.buttons["Login"].tap()
            
            let elementsQuery = app.alerts["Login error"].scrollViews.otherElements
            let errorText = elementsQuery.staticTexts["There is no user record corresponding to this identifier. The user may have been deleted."]
            XCTAssertTrue(errorText.exists)
            
            elementsQuery.buttons["OK"].tap()
        } else {
            //logout
            app.navigationBars["Empty core data"].buttons["line.horizontal.3"].tap()
            app.tables.cells.containing(.image, identifier:"xmark.circle").children(matching: .other).element(boundBy: 0).tap()
            sleep(5)
            testInvalidLogin_alertAppears()
        }
        
    }
    
    //MARK: Test CorrectLogin
    func testCorrectLogin (){
        
        let app = XCUIApplication()
        app.launch()
        
        if app.staticTexts["Login"].exists {
            let uName = "Testiukko"
            let pass = "Test1!"
            //app.navigationBars["Empty core data"].buttons["Auth"].tap()
            
            let uField = app.textFields["Username"]
            uField.tap()
            uField.typeText(uName)
            
            let pField =  app.secureTextFields["Password"]
            pField.tap()
            pField.typeText(pass)
            
            XCUIApplication().buttons["Login"].tap()
            
            let allButton = XCUIApplication()/*@START_MENU_TOKEN@*/.buttons["All"]/*[[".segmentedControls.buttons[\"All\"]",".buttons[\"All\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
            allButton.tap()
            
            XCTAssertTrue(allButton.exists)
        } else {
            //logout
            app.navigationBars["Empty core data"].buttons["line.horizontal.3"].tap()
            app.tables.cells.containing(.image, identifier:"xmark.circle").children(matching: .other).element(boundBy: 0).tap()
            sleep(5)
            testCorrectLogin()
        }
    }
    
    //MARK: Test InvalidRegister
    func testInvalidRegister (){
        
        let app = XCUIApplication()
        app.launch()
        
        if app.staticTexts["Login"].exists {
            //app.navigationBars["Empty core data"].buttons["Auth"].tap()
            app.buttons["Go to register"].tap()
            
            let registerStaticText = app.buttons["Register"].staticTexts["Register"]
            registerStaticText.tap()
            
            let elementsQuery = app.alerts["Register error"].scrollViews.otherElements
            elementsQuery.staticTexts["The password must be 6 characters long or more."].tap()
            
            let okButton = elementsQuery.buttons["OK"]
            XCTAssertTrue(okButton.exists)
            okButton.tap()
            
        } else {
            //logout
            app.navigationBars["Empty core data"].buttons["line.horizontal.3"].tap()
            app.tables.cells.containing(.image, identifier:"xmark.circle").children(matching: .other).element(boundBy: 0).tap()
            sleep(5)
            testInvalidRegister()
        }
    }
    
    //MARK: Test Jokes
    func testJokes() {
        let app = XCUIApplication()
        app.launch()
        
        if app.staticTexts["Login"].exists {
            XCUIApplication().buttons["Continue as guest"].tap()
            sleep(5)
            testJokes()
        } else {
            app.navigationBars["Empty core data"].buttons["line.horizontal.3"].tap()
            app.tables.cells.containing(.image, identifier:"trash").children(matching: .other).element(boundBy: 0).tap()
            app.buttons["Next Joke"].tap()
            let jokeText = app.staticTexts["Jokes"]
            XCTAssert(jokeText.exists)
            app.navigationBars.buttons["Back"].tap()
        }
    }
    
    //MARK: Test CovidTracker
    func testCovidTracker() {
        let app = XCUIApplication()
        app.launch()
        
        if app.staticTexts["Login"].exists {
            XCUIApplication().buttons["Continue as guest"].tap()
            sleep(5)
            testCovidTracker()
            
        } else {
            app.tabBars.buttons["Covid-19"].tap()
        }
    }
    
    //MARK: Test LaunchPerformance
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}

