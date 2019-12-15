//
//  Notes_appUITests.swift
//  Notes appUITests
//
//  Created by Andrii Kryvytskyi on 10.12.2019.
//  Copyright © 2019 Andrii Kryvytskyi. All rights reserved.
//

import XCTest

class Notes_app_MasterView_UI_tests: XCTestCase {

    var app: XCUIApplication!
    var elementsIserted: Int = 0
    
    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func addNoteElement(noteTilte: String, noteText: String) {
        
        app.navigationBars.buttons["Add Note"].tap()
        
        let textField = app.textFields["Note title input"]
        
        if textField.waitForExistence(timeout: 10) {
        
            textField.tap()
            textField.typeText(noteTilte)

            let noteTextInputTextView = app.textViews["Note text input"]
            noteTextInputTextView.tap()
            
            noteTextInputTextView.typeText(noteText)
            app.buttons["Done"].tap()
        } else { XCTFail() }
        
        elementsIserted+=1
        
    }
    
    func deleteAllElements () {
        let notesListNavigationBar = app.navigationBars["Notes List"]

        notesListNavigationBar.buttons["Edit"].tap()
        
        let tablesQuery = app.tables
        for i in (0...elementsIserted-1).reversed() {
            tablesQuery.buttons.element(boundBy: i).tap()
            tablesQuery.buttons["trailing0"].tap()
        }
        
        notesListNavigationBar.buttons["Done"].tap()
        
        self.elementsIserted = 0
    }

    func testMasterViewControllerAddNote() {
        self.addNoteElement(noteTilte: "Geat title", noteText: "Meaningful text")

        let cell = app.tables.element(boundBy: 0).cells

        let predicate = NSPredicate(format: "label CONTAINS[c] %@", "Geat title")
        let elementQuery = cell.containing(predicate)
        
        XCTAssertEqual(elementQuery.count > 0, true, "should be shown")
        
        deleteAllElements()
    }
    
    func testSearchBarController() {
        
        let targetTitle = "Pattern title"
        
        for i in 0...3 {
            self.addNoteElement(noteTilte: "Geat title №\(i)", noteText: "Meaningful text")
        }
        
        self.addNoteElement(noteTilte: targetTitle, noteText: "Meaningful text")
        
        app.tables.element(boundBy: 0).cells.element(boundBy: 0).swipeDown()
        
        let searchBar = app.navigationBars["Notes List"].searchFields["Search Notes"]
        
        searchBar.tap()
        searchBar.typeText(targetTitle)
        app/*@START_MENU_TOKEN@*/.buttons["Search"]/*[[".keyboards",".buttons[\"search\"]",".buttons[\"Search\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let cell = app.tables.element(boundBy: 0).cells
        
        cell.element(boundBy: 0).swipeDown()

        let predicate = NSPredicate(format: "label CONTAINS[c] %@", targetTitle)
        let elementQuery = cell.containing(predicate)
        
        XCTAssertEqual(elementQuery.count > 0, true, "should be shown")
        
        app.buttons["Cancel"].tap()
        
        deleteAllElements()
    }
    
    func testEditButton() {
        for i in 0...3 {
            self.addNoteElement(noteTilte: "Geat title №\(i)", noteText: "Meaningful text")
        }
        
        deleteAllElements()
    }
    
    func testSwipeToDelete() {
        for i in 0...3 {
            self.addNoteElement(noteTilte: "Geat title №\(i)", noteText: "Meaningful text")
        }
        
        let tablesQuery = app.tables.cells
        
        for i in (0...3).reversed() {
            tablesQuery.element(boundBy: i).swipeLeft()
            tablesQuery.element(boundBy: i).buttons["Delete"].tap()
        }
        
        let cell = app.tables.element(boundBy: 0).cells
        let predicate = NSPredicate(format: "label CONTAINS[c] %@", "Geat title")
        let elementQuery = cell.containing(predicate)
        
        XCTAssertEqual(elementQuery.count == 0, true, "shouldn't be shown")
        
        self.elementsIserted = 0
    }
    
    func testShowWeatherView() {
        let notesListNavigationBar = app.navigationBars["Notes List"]
        let weatherButton = notesListNavigationBar.buttons["Weather"]

        if weatherButton.waitForExistence(timeout: 10) {
            weatherButton.tap()
        } else {
            XCTFail()
        }
        
        let weatherController = app.navigationBars["Weather"]
        if weatherController.waitForExistence(timeout: 10) {
            weatherController.buttons["Notes List"].tap()
            sleep(2)
        } else {
            XCTFail()
        }
    }
}
