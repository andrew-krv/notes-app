//
//  WeatherTableViewController.swift
//  Notes app
//
//  Created by Andrii Kryvytskyi on 06.12.2019.
//  Copyright © 2019 Andrii Kryvytskyi. All rights reserved.
//

import Foundation
import UIKit

class WeatherTableViewController : UITableViewController {
    var weatherItems: Array<WeatherClass> = Array()
    private let weatherWorker = WeatherWebWorker(
        baseURL: WeatherWebAPI.AuthenticatedBaseURL,
        timeType:  "daily")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loadingWeather = UIAlertController(title: nil, message: "Loading data", preferredStyle: .alert)
            
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();

        loadingWeather.view.addSubview(loadingIndicator)
        // self.present(loadingWeather, animated: true, completion: nil)

        DispatchQueue.main.async {

            self.initializeTableContent()
            self.tableView.reloadData()
            
        }
        // self.dismiss(animated: true, completion: nil)
    }
    
    private func initializeTableContent() {
        weatherItems = weatherWorker.weatherDataForLocation(
            latitude: WeatherDefaults.Latitude,
            longitude: WeatherDefaults.Longitude) { (error:WeatherWebWorkerError? ) in
                if error != nil {
                    let alert = UIAlertController(
                        title: "Error",
                        message: "\(error!)",
                        preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK",
                                                  style: .default))
                    self.present(alert, animated: true)
                    return
                }
            }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

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
            cell.TemperatureLabel!.text = "\(object.weatherTemperature)°C"
            cell.StatusLabel!.text = object.weatherStatus
            cell.WindDirectionLabel!.text = object.weatherWindDirection
            cell.WindSpeedLabel!.text = "\(object.weatherWindSpeed)km/h"
            cell.PreviewImage!.image = object.weatherPreview
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
}


