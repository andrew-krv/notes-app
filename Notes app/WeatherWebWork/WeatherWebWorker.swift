//
//  WeatherWebWorker.swift
//  Notes app
//
//  Created by Andrii Kryvytskyi on 05.12.2019.
//  Copyright © 2019 Andrii Kryvytskyi. All rights reserved.
//

import Foundation

enum WeatherWebWorkerError: Error {

    case Unknown
    case FailedRequest
    case InvalidResponse
    
}

final class WeatherWebWorker {

    typealias WeatherDataCompletion = (AnyObject?, WeatherWebWorkerError?) -> ()

    let baseURL: URL

    // MARK: - Initialization

    init(baseURL: URL) {
        self.baseURL = baseURL
    }

    // MARK: - Requesting Data

    func weatherDataForLocation(
        latitude: Double,
        longitude: Double,
        completion: @escaping WeatherDataCompletion) {
        // Create URL
        let URL = baseURL.appendingPathComponent("\(latitude),\(longitude)")

        // Create Data Task
        URLSession.shared.dataTask(with: URL) { (data, response, error) in
            self.didFetchWeatherData(data: data, response: response, error: error, completion: completion)
            }.resume()
    }

    // MARK: - Helper Methods

    private func didFetchWeatherData(
        data: Data?,
        response: URLResponse?,
        error: Error?,
        completion: @escaping WeatherDataCompletion) {
        if let _ = error {
            completion(nil, .FailedRequest)

        } else if let data = data, let response = response as? HTTPURLResponse {
            if response.statusCode == 200 {
                processWeatherData(data: data, completion: completion)
            } else {
                completion(nil, .FailedRequest)
            }

        } else {
            completion(nil, .Unknown)
        }
    }

    private func processWeatherData(data: Data, completion: @escaping WeatherDataCompletion) {
        if let JSON = try? JSONSerialization.jsonObject(with: data, options: []) as AnyObject {
            completion(JSON, nil)
        } else {
            completion(nil, .InvalidResponse)
        }
    }

}
