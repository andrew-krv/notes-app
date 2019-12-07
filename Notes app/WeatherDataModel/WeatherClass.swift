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
    private(set) var weatherWindDirection   : String
    private(set) var weatherWindSpeed       : Double
    private(set) var weatherPreview         : UIImage

    init(
        weatherDate: String,
        weatherTemperature:Double,
        weatherStatus:String,
        weatherWindDirection:String,
        weatherWindSpeed:Double,
        weatherPreview:UIImage
        ) throws {
        self.weatherDate            = weatherDate
        self.weatherTemperature     = weatherTemperature
        self.weatherStatus          = weatherStatus
        self.weatherWindDirection   = weatherWindDirection
        self.weatherWindSpeed       = weatherWindSpeed
        self.weatherPreview         = weatherPreview
    }
    
    init(json:[String: Any], timeType:String) throws {
        print(json)
        switch timeType {
        case "currently":
            guard let weatherTemperature = json["apparentTemperature"] as? Double else {
            throw SerializationError.missing("apparentTemperature is missing")}
            
            guard let weatherTime = json["time"] as? Double else {
            throw SerializationError.missing("apparentTemperature is missing")}
            
            self.weatherDate = NotesAppDateHelper.convertDate(
                date: Date.init(timeIntervalSince1970:weatherTime),
                dateFormat:"EEEE, MMM d, yyyy, hh:mm:ss")
            
            self.weatherTemperature     = weatherTemperature
        case "hourly":
            guard let weatherTemperature = json["apparentTemperature"] as? Double else {
            throw SerializationError.missing("apparentTemperature is missing")}
            
            guard let weatherTime = json["time"] as? Double else {
            throw SerializationError.missing("apparentTemperature is missing")}
            
            self.weatherDate = NotesAppDateHelper.convertDate(
                date: Date.init(timeIntervalSince1970:weatherTime),
                dateFormat:"EEEE, MMM d, yyyy, hh")
            
            self.weatherTemperature     = weatherTemperature
        case "daily":
            guard let weatherTemperature = json["temperatureHigh"] as? Double else {
            throw SerializationError.missing("temperatureHigh is missing")}
            
            guard let weatherTime = json["time"] as? Double else {
            throw SerializationError.missing("apparentTemperature is missing")}
            
            self.weatherDate = NotesAppDateHelper.convertDate(
                date: Date.init(timeIntervalSince1970:weatherTime),
                dateFormat:"EEEE, MMM d, yyyy, hh")
            
            self.weatherTemperature     = weatherTemperature

        default:
            throw SerializationError.missing("label \(timeType) is missing")
            
        }

        guard let weatherStatus = json["summary"] as? String else {
            throw SerializationError.missing("summary is missing")}

        guard let weatherWindDirection = json["windBearing"] as? Double else {
            throw SerializationError.missing("windBearing is missing")}
        
        guard let weatherWindSpeed = json["windSpeed"] as? Double else {
               throw SerializationError.missing("windSpeed is missing")}
        
        guard let weatherPreviewString = json["icon"] as? String else {
            throw SerializationError.missing(("icon is missing"))
        }
        
        
        self.weatherStatus          = weatherStatus
        self.weatherWindDirection   = WeatherClass.convertWindDirectionToString(windBearing: weatherWindDirection)
        self.weatherWindSpeed       = weatherWindSpeed * 0.621371 //Convert to km/h
        self.weatherPreview         = WeatherClass.transformStringToIcon(iconString: weatherPreviewString)
        
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
        let ArrayIndex = Int((windBearing / 22.5) + 0.5)

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
        
        return WindDirNames[ArrayIndex]
    }
    
    
}
