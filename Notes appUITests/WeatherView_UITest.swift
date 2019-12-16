//
//  WeatherView_UITest.swift
//  Notes appUITests
//
//  Created by Andrii Kryvytskyi on 16.12.2019.
//  Copyright © 2019 Andrii Kryvytskyi. All rights reserved.
//

import XCTest

class Notes_app_WeatherView_UI_tests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testShowWeatherViewQueryTableItems() {
        let notesListNavigationBar = app.navigationBars["Notes List"]
        let weatherButton = notesListNavigationBar.buttons["Weather"]

        if weatherButton.waitForExistence(timeout: 10) {
            weatherButton.tap()
        } else {
            XCTFail()
        }
        
        let weatherController = app.navigationBars["Weather"]
        if weatherController.waitForExistence(timeout: 10) {
            let weatherCellsQuery = app.tables.element(boundBy: 0).cells
            let windPredicate = NSPredicate(format: "label CONTAINS[c] %@", "Wind:")
            let windElementQuery = weatherCellsQuery.containing(windPredicate)
            
            XCTAssertEqual(windElementQuery.count > 0, true, "should be shown")
            
            let humidityPredicate = NSPredicate(format: "label CONTAINS[c] %@", "Humidity:")
            let humidityElementQuery = weatherCellsQuery.containing(humidityPredicate)
            
            XCTAssertEqual(humidityElementQuery.count > 0, true, "should be shown")
            XCTAssertEqual(humidityElementQuery.count == windElementQuery.count, true, "should be shown")
        } else {
            XCTFail()
        }
        
    }
    
    func testShowWeatherViewQueryDailyTableItems() {
        let notesListNavigationBar = app.navigationBars["Notes List"]
        let weatherButton = notesListNavigationBar.buttons["Weather"]

        if weatherButton.waitForExistence(timeout: 10) {
            weatherButton.tap()
        } else {
            XCTFail()
        }
        
        let weatherController = app.navigationBars["Weather"]
        if weatherController.waitForExistence(timeout: 10) {
            let dailyWeather = app.navigationBars["Weather"].buttons["Daily weather"]
            if dailyWeather.waitForExistence(timeout: 10) {
                dailyWeather.tap()

                let weatherCellsQuery = app.tables.element(boundBy: 0).cells
                let windPredicate = NSPredicate(format: "label CONTAINS[c] %@", "Wind:")
                let windElementQuery = weatherCellsQuery.containing(windPredicate)
                
                XCTAssertEqual(windElementQuery.count > 0, true, "should be shown")
                
                let humidityPredicate = NSPredicate(format: "label CONTAINS[c] %@", "Humidity:")
                let humidityElementQuery = weatherCellsQuery.containing(humidityPredicate)
                
                XCTAssertEqual(humidityElementQuery.count > 0, true, "should be shown")
                XCTAssertEqual(humidityElementQuery.count == windElementQuery.count, true, "should be shown")
            }
            
        } else {
            XCTFail()
        }
        
    }
    
    func testShowWeatherViewDailyWeatherQueryTableItems() {
    }
}
