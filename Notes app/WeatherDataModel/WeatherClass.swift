//
//  WeatherClass.swift
//  Notes app
//
//  Created by Andrii Kryvytskyi on 05.12.2019.
//  Copyright © 2019 Andrii Kryvytskyi. All rights reserved.
//

import Foundation
import UIKit

enum  SerializationError:Error {
    case missing(String)  //ex: key does not exist
    case invalid(String, Any)
}

class WeatherClass {
    private(set) var weatherDate            : String
    private(set) var weatherTemperature     : Double
    private(set) var weatherStatus          : String
    private(set) var weatherHumidity        : Int
    private(set) var weatherWindDirection   : String
    private(set) var weatherWindSpeed       : Double
    private(set) var weatherPreview         : UIImage

    init(
        weatherDate: String,
        weatherTemperature:Double,
        weatherStatus:String,
        weatherHumidity:Int,
        weatherWindDirection:String,
        weatherWindSpeed:Double,
        weatherPreview:UIImage
        ) throws {
        self.weatherDate            = weatherDate
        self.weatherTemperature     = weatherTemperature
        self.weatherStatus          = weatherStatus
        self.weatherHumidity        = weatherHumidity
        self.weatherWindDirection   = weatherWindDirection
        self.weatherWindSpeed       = weatherWindSpeed
        self.weatherPreview         = weatherPreview
    }
    
    init(json:[String: Any], timeType:String) throws {
        guard let weatherStatus = json["summary"] as? String else {
            throw SerializationError.missing("summary is missing")}
        
        guard let weatherHumidity = json["humidity"] as? Double else {
            throw SerializationError.missing("humidity is missing")}

        guard let weatherWindDirection = json["windBearing"] as? Double else {
            throw SerializationError.missing("windBearing is missing")}
        
        guard let weatherWindSpeed = json["windSpeed"] as? Double else {
               throw SerializationError.missing("windSpeed is missing")}
        
        guard let weatherPreviewString = json["icon"] as? String else {
            throw SerializationError.missing(("icon is missing"))
        }
        
        guard let weatherTime = json["time"] as? Double else {
            throw SerializationError.missing("time is missing")
        }
        
        self.weatherStatus          = weatherStatus
        self.weatherHumidity        = Int(round(weatherHumidity * 100))
        self.weatherWindDirection   = WeatherClass.convertWindDirectionToString(windBearing: weatherWindDirection)
        self.weatherWindSpeed       = weatherWindSpeed * 0.621371 //Convert to km/h
        self.weatherPreview         = WeatherClass.transformStringToIcon(iconString: weatherPreviewString)
        
        switch timeType {
        case "hourly":
            guard let weatherTemperature = json["apparentTemperature"] as? Double else {
            throw SerializationError.missing("apparentTemperature is missing")}
            
            self.weatherDate = NotesAppDateHelper.convertDate(
                date: Date.init(timeIntervalSince1970:weatherTime),
                dateFormat:"HH:mm")
            
            self.weatherTemperature     = weatherTemperature - 32
        case "daily":
            guard let weatherTemperature = json["temperatureHigh"] as? Double else {
            throw SerializationError.missing("temperatureHigh is missing")}

            self.weatherDate = NotesAppDateHelper.convertDate(
                date: Date.init(timeIntervalSince1970:weatherTime),
                dateFormat:"EEEE")
            
            self.weatherTemperature     = weatherTemperature - 32

        default:
            throw SerializationError.missing("label \(timeType) is missing")
            
        }
        self.weatherTemperature     = round(10 * (self.weatherTemperature) / 10) // convert to celsius
        
    }
    
    static private func transformStringToIcon (iconString: String) -> UIImage {
        switch iconString {
        case "clear-day":
            return UIImage(systemName: "sun.min")!
        case "clear-night":
            return UIImage(systemName: "moon.stars")!
        case "rain":
            return UIImage(systemName: "cloud.rain")!
        case "snow":
            return UIImage(systemName: "cloud.snow")!
        case "sleet":
            return UIImage(systemName: "cloud.sleet")!
        case "wind":
            return UIImage(systemName: "wind")!
        case "fog":
            return UIImage(systemName: "cloud.fog")!
        case "cloudy":
            return UIImage(systemName: "cloud")!
        case "partly-cloudy-day":
            return UIImage(systemName: "cloud.sun")!
        case "partly-cloudy-night":
            return UIImage(systemName: "cloud.moon")!
        
        default:
            return UIImage(systemName: "sun.min")!
        }
    }
    
   static  private func convertWindDirectionToString (windBearing: Double) -> String {
        var ArrayIndex = Int((windBearing / 22.5) + 0.5)

        let WindDirNames = [
            "N",
            "NNE",
            "NE",
            "ENE",
            "E",
            "ESE",
            "SE",
            "SSE",
            "S",
            "SSW",
            "SW",
            "WSW",
            "W",
            "WNW",
            "NW",
            "NNW"
        ]

        ArrayIndex = ArrayIndex > 15 ? 15 : ArrayIndex

        return WindDirNames[ArrayIndex]
    }
    
    
}
