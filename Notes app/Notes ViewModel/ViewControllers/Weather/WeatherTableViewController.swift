//
//  WeatherTableViewController.swift
//  Notes app
//
//  Created by Andrii Kryvytskyi on 06.12.2019.
//  Copyright © 2019 Andrii Kryvytskyi. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class WeatherTableViewController : UITableViewController {
    private var weatherItems: Array<WeatherClass> = Array()
    private var location =  CLLocationCoordinate2D()
    private(set) var segmentedControl: UISegmentedControl = UISegmentedControl()

    private let weatherWorker = WeatherWebWorker(
        baseURL: WeatherWebAPI.AuthenticatedBaseURL,
        timeType:  "hourly")
    
    // MARK: viewDidLoad()
    
    override func viewDidLoad() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else {
            let alert = UIAlertController(
                title: "Could note get app delegate",
                message: "Could note get app delegate, unexpected error occurred. Try again later.",
                preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .default))
            self.present(alert, animated: true)

            return
        }
        location = appDelegate.getLocation()
        DispatchQueue.main.async {

            self.initializeTableContent()
            self.tableView.reloadData()
            
        }
        
        self.segmentedControl = UISegmentedControl(items: ["Daily weather", "Hourly weather"])
        self.segmentedControl.sizeToFit()
        self.segmentedControl.tintColor = UIColor(red:0.99, green:0.00, blue:0.25, alpha:1.00)
        self.segmentedControl.selectedSegmentIndex = 1;
        self.segmentedControl.addTarget(self, action: #selector(segmentedControlClicked), for: .valueChanged)
        self.navigationItem.titleView = segmentedControl
    }
    
    // MARK: Fetching data
    
    private func initializeTableContent() {
        weatherItems.removeAll()
        weatherWorker.weatherDataForLocation(
            latitude: location.latitude,
            longitude: location.longitude) { (data:Array<WeatherClass>?, error:WeatherWebWorkerError? ) in
                if error != nil {
                    let alert = UIAlertController(
                        title: "Error",
                        message: "\(error!)",
                        preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK",
                                                  style: .default))
                    self.present(alert, animated: true)
                    return
                } else {
                    if let weatherItemFromWeb = data {
                        self.weatherItems = weatherItemFromWeb
                        //this is to perform data transfer (asynchronously) to the main thread in order to update UI
                        DispatchQueue.main.sync {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
    }

    // MARK: - Table View

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return objects.count
        return weatherItems.count
    }

    override func tableView(
            _ tableView: UITableView,
            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WeatherListViewController

        if weatherItems.indices.contains(indexPath.row) {
            let object = weatherItems[indexPath.row]
            cell.DateLabel!.text = object.weatherDate
            cell.TemperatureLabel!.text = "\(Int(round(object.weatherTemperature)))°C"
            cell.StatusLabel!.text = object.weatherStatus
            cell.HumidityLabel!.text = "Humidity: \(object.weatherHumidity) %"
            cell.WindLabel!.text = "Wind: \(object.weatherWindDirection) \(Double(round(10*object.weatherWindSpeed)/10)) km/h"
            cell.PreviewImage!.image = object.weatherPreview
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Doing nothing in case of editing
        return
    }

    // MARK: Segmented Control
    @IBAction func segmentedControlClicked(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            weatherWorker.resetTimeType(timeType: "daily")
        case 1:
            weatherWorker.resetTimeType(timeType: "hourly")
        default:
            weatherWorker.resetTimeType(timeType: "daily")
        }
        
        DispatchQueue.main.async {
            self.initializeTableContent()
            self.tableView.reloadData()
        }
        self.tableView.reloadData()
    }
}


