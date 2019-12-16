//
//  WeatherWebWorker_Tests.swift
//  Notes appTests
//
//  Created by Andrii Kryvytskyi on 16.12.2019.
//  Copyright © 2019 Andrii Kryvytskyi. All rights reserved.
//

import XCTest
@testable import Notes_app

class WeatherWebWorker_Tests: XCTestCase {
    
    private var weatherItems = Array<WeatherClass>()
    private let weatherWorker = WeatherWebWorker(
        baseURL: WeatherWebAPI.AuthenticatedBaseURL,
        timeType:  "hourly")
    
    func fetchWeatherItems () {
        let expectation = XCTestExpectation(description: "Download weather items form darksky API")
        
        weatherItems.removeAll()
        weatherWorker.weatherDataForLocation(
            latitude: WeatherWebAPI.default_longitude,
            longitude: WeatherWebAPI.default_latitude) {
                (data:Array<WeatherClass>?, error:WeatherWebWorkerError? ) in
                if error != nil {
                    XCTFail()
                    return
                } else {
                    XCTAssertNotNil(data, "No data was downloaded.")
                    self.weatherItems = data!
                        
                    DispatchQueue.main.sync {
                        expectation.fulfill()
                    }
                }
            }
        
        wait(for: [expectation], timeout: 10.0)
    }

    override func setUp() {
        continueAfterFailure = false
    }

    func testFetchHourlyWeatherForDefaultLocation() {
        self.weatherWorker.resetTimeType(timeType: "hourly")
        self.fetchWeatherItems()
        
        XCTAssert(weatherItems.count > 0)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testFetchDailyWeatherForDefaultLocation() {
        self.weatherWorker.resetTimeType(timeType: "daily")
        self.fetchWeatherItems()
        
        XCTAssert(weatherItems.count > 0)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
}
