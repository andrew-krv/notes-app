//
//  WeatherJsonMock_tests.swift
//  Notes appTests
//
//  Created by Andrii Kryvytskyi on 16.12.2019.
//  Copyright © 2019 Andrii Kryvytskyi. All rights reserved.
//

import XCTest
import Foundation
@testable import Notes_app

enum JsonParserError: Error {

    case FailedToGetFile
    case FailedToSerialize
    case FailedToGetContent
    
}

class WeatherJsonMock_tests: XCTestCase {
    
    private var weatherItems = Array<WeatherClass>()
        private let weatherWebWorkerInstance = WeatherWebWorker(
            baseURL: WeatherWebAPI.AuthenticatedBaseURL,
            timeType:  "hourly")

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        weatherItems.removeAll()
    }
    
    func parseJson(timeType: String, fileName: String, expectedError: WeatherWebWorkerError?) {
        weatherWebWorkerInstance.resetTimeType(timeType: timeType)
        let bundle = Bundle(for: type(of: self))
        guard let jsonPath = bundle.path(forResource: fileName, ofType: "json") else {
            XCTFail("Missing file: \(fileName).json")
            return
        }
        
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: jsonPath), options: .alwaysMapped) else {
            XCTFail()
            return
        }
        
        weatherWebWorkerInstance.processWeatherData (data: data){
            (data:Array<WeatherClass>?, error:WeatherWebWorkerError? ) in
            if error != nil {
                if error != expectedError {
                    XCTFail("Unexpected error occured: \(error!.localizedDescription)")
                }
            } else {
                XCTAssertNotNil(data, "No data was downloaded.")
                self.weatherItems = data!
            }
        }
    }

    func testDaily_WeatherParseJson() {
        parseJson(timeType: "daily", fileName: "WeatherData", expectedError: nil)
        XCTAssert(weatherItems.count == 8, "Expected json has 8 daily elements")
    }
    
    func testHourly_WeatherParseJson() {
        parseJson(timeType: "hourly", fileName: "WeatherData", expectedError: nil)
        XCTAssert(weatherItems.count == 49, "Exptected json has 49 hourly elements")
    }
    
    func testNoHourly_DailyWeatherParseJson() {
        parseJson(timeType: "daily", fileName: "WeatherDataNoHourly", expectedError: nil)
        XCTAssert(weatherItems.count == 8, "Expected json has 8 daily elements")
    }
    
    func testNoHourly_HourlyWeatherParseJson() {
        parseJson(timeType: "hourly", fileName: "WeatherDataNoHourly", expectedError: .FailedRequest)
        XCTAssert(weatherItems.count == 0, "Exptected json has 0 hourly elements")
    }
    
    func testNoDaily_DailyWeatherParseJson() {
        parseJson(timeType: "daily", fileName: "WeatherDataNoDaily", expectedError: .FailedRequest)
        XCTAssert(weatherItems.count == 0, "Expected json has 0 daily elements")
    }
    
    func testNoDaily_HourlyWeatherParseJson() {
        parseJson(timeType: "hourly", fileName: "WeatherDataNoDaily", expectedError: nil)
        XCTAssert(weatherItems.count == 49, "Exptected json has 0 hourly elements")
    }

}
