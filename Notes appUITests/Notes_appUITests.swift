//
//  Notes_appUITests.swift
//  Notes appUITests
//
//  Created by Andrii Kryvytskyi on 10.12.2019.
//  Copyright © 2019 Andrii Kryvytskyi. All rights reserved.
//

import XCTest

class Notes_appUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMasterVievController() {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testMasterViewControllerAddNote() {
        let app = XCUIApplication()
        app.navigationBars["Notes List"].buttons["Add"].tap()
        app.textFields["New Note 1"].tap()
        
        let textView = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .textView).element
        textView.tap()
        textView.tap()
        app.navigationBars["Master"].buttons["Done"].tap()
    }
    
    func testMasterViewControllerAddNoteWithAttachment() {
        
        let app = XCUIApplication()
        let notesListNavigationBar = app.navigationBars["Notes List"]
        let addButton = notesListNavigationBar.buttons["Add"]
        addButton.tap()
        
        let newNote1TextField = app.textFields["New Note 1"]
        newNote1TextField.tap()
        newNote1TextField.tap()
        
        let textView = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .textView).element
        textView.tap()
        textView.tap()
        
        let doneButton = app.navigationBars["Master"].buttons["Done"]
        doneButton.tap()
        
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["note text"]/*[[".cells[\"note text, Note text here, Tuesday, Dec 10, 2019, 01:38:50\"].staticTexts[\"note text\"]",".staticTexts[\"note text\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Note Details"].buttons["Notes List"].tap()
        addButton.tap()
        newNote1TextField.tap()
        textView.tap()
        textView.tap()
        doneButton.tap()
        notesListNavigationBar.buttons["magnifyingglass"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Note text here"]/*[[".cells[\"note with searchword, Note text here, Tuesday, Dec 10, 2019, 01:39:02\"].staticTexts[\"Note text here\"]",".staticTexts[\"Note text here\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
                
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
