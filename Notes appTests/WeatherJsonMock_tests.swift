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

class WeatherJsonMock_tests: XCTestCase {
    
    private var weatherItems = Array<WeatherClass>()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func parseJson(timeType: String) {
        let bundle = Bundle(for: type(of: self))
        guard let jsonPath = bundle.path(forResource: "WeatherData", ofType: "json") else {
            XCTFail("Missing file: WeatherData.json")
            return
        }
        
        if let data = try? Data(contentsOf: URL(fileURLWithPath: jsonPath), options: .alwaysMapped) {
            if let JSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                if let dailyForecasts = JSON[timeType] as? [String:Any]{
                    if let dailyData = dailyForecasts["data"] as? [[String: Any]] {
                        for dataPoint in dailyData {
                            if let weatherObject = try? WeatherClass(json: dataPoint, timeType: timeType) {
                                    weatherItems.append(weatherObject)
                            }
                        }
                    }
                } else {
                    XCTFail()
                }
            }
        }
    }

    func testParseJson() {
        parseJson(timeType: "hourly")
        
        XCTAssert(weatherItems.count > 0)
    }
    
    func testHourlyWeatherParseJson() {
        parseJson(timeType: "daily")
        
        XCTAssert(weatherItems.count > 0)
    }

}
