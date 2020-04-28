//
//  JokesViewControllerTests.swift
//  QuarantineAppTests
//
//  Created by Roope Vaarama on 28.4.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//
import XCTest
@testable import QuarantineApp

class JokesViewControllerTests: XCTestCase {

  /*  override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
*/

    /*func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }*/
    func testnextJoke(){
       let storyboard = UIStoryboard(name: "Jokes", bundle: nil)
       let JokesVC = storyboard.instantiateViewController(withIdentifier: "jokes") as! JokesViewController
       
       _ = JokesVC.view
       
       JokesVC.nextJoke()
       XCTAssert(JokesVC.number == 2, "Next joke didnt work")
       
    }
}
