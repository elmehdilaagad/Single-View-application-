//
//  UITests.swift
//  UITests
//
//  Created by Laagad El Mehdi on 15/02/2016.
//  Copyright © 2016 Laagad El Mehdi. All rights reserved.
//

import XCTest

class UITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testExample() {
        
        
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery.staticTexts["The Beatles 1962-1966 (The Red Album)"].tap()
        tablesQuery.staticTexts["Love Me Do"].tap()
        tablesQuery.cells.containingType(.StaticText, identifier:"Love Me Do").childrenMatchingType(.StaticText).matchingIdentifier("Love Me Do").elementBoundByIndex(0).tap()
        tablesQuery.staticTexts["I Want to Hold Your Hand"].tap()
        tablesQuery.cells.containingType(.StaticText, identifier:"I Want to Hold Your Hand").childrenMatchingType(.StaticText).matchingIdentifier("I Want to Hold Your Hand").elementBoundByIndex(0).tap()
        app.navigationBars["HelloWorld.DetailView"].childrenMatchingType(.Button).matchingIdentifier("Back").elementBoundByIndex(0).tap()
        
  
    }
    
}
