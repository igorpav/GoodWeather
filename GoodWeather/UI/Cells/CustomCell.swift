//
//  CustomCell.swift
//  GoodWeather
//
//  Created by Игорь Павличенков on 17.12.2021.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var nameCityLabel: UILabel!
    @IBOutlet weak var conditionCityLabel: UILabel!
    @IBOutlet weak var tempertatureCityLabel: UILabel!
    
    func configure (weather: Weather) {
        
        self.nameCityLabel.text = weather.name
        self.conditionCityLabel.text = weather.conditionString
        self.tempertatureCityLabel.text = String(weather.temperature) + " °C"
        
    }
    
}
