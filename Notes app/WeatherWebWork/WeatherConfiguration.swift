//
//  WeatherConfiguration.swift
//  Notes app
//
//  Created by Andrii Kryvytskyi on 05.12.2019.
//  Copyright © 2019 Andrii Kryvytskyi. All rights reserved.
//

import Foundation

struct WeatherDefaults {

    static let Latitude: Double = 50.447731
    static let Longitude: Double = 30.542721

}

struct WeatherWebAPI {

    static let APIKey = "23c7cfc9f7a80e48661c82513defce10"
    static let BaseURL = URL(string: "https://api.forecast.io/forecast/")!

    static var AuthenticatedBaseURL: URL {
        return BaseURL.appendingPathComponent(APIKey)
    }

}
