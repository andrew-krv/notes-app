//
//  WeatherListViewController.swift
//  Notes app
//
//  Created by Andrii Kryvytskyi on 06.12.2019.
//  Copyright © 2019 Andrii Kryvytskyi. All rights reserved.
//

import UIKit

class WeatherListViewController : UITableViewCell {
    private(set) var weatherDate            : String = ""
    private(set) var weatherTemperature     : String = ""
    private(set) var weatherStatus          : String = ""
    private(set) var weatherWindDirection   : String = ""
    private(set) var weatherWind            : String = ""
    private(set) var weatherHumidity        : String = ""
    private(set) var weatherPreview         : UIImage = UIImage()
    
    @IBOutlet weak var DateLabel            : UILabel!
    @IBOutlet weak var TemperatureLabel     : UILabel!
    @IBOutlet weak var StatusLabel          : UILabel!
    @IBOutlet weak var WindLabel            : UILabel!
    @IBOutlet weak var HumidityLabel        : UILabel!
    @IBOutlet weak var PreviewImage         : UIImageView!
}
