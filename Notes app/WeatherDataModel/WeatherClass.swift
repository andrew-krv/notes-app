//
//  WeatherClass.swift
//  Notes app
//
//  Created by Andrii Kryvytskyi on 05.12.2019.
//  Copyright © 2019 Andrii Kryvytskyi. All rights reserved.
//

import Foundation
import CoreImage

class WeatherClass {
    private(set) var weatherDate            : String
    private(set) var weatherTemperature     : Int64
    private(set) var weatherStatus          : String
    private(set) var weatherWindDirection   : String
    private(set) var weatherWindSpeed       : Int64
    private(set) var weatherPreview         : CIImage

    init(
        weatherDate: String,
        weatherTemperature:Int64,
        weatherStatus:String,
        weatherWindDirection:String,
        weatherWindSpeed:Int64,
        weatherPreview:CIImage
        ) {
        self.weatherDate            = weatherDate
        self.weatherTemperature     = weatherTemperature
        self.weatherStatus          = weatherStatus
        self.weatherWindDirection   = weatherWindDirection
        self.weatherWindSpeed       = weatherWindSpeed
        self.weatherPreview         = weatherPreview
    }
}
