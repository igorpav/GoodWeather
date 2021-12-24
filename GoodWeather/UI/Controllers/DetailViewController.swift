//
//  DetailViewController.swift
//  GoodWeather
//
//  Created by Игорь Павличенков on 22.12.2021.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var nameCityLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var tempCityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
    @IBOutlet weak var tempMaxLabel: UILabel!
    
    var weatherModel : Weather?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshLabels()
        
    }
    
    func refreshLabels() {
        
        nameCityLabel.text = weatherModel?.name
        weatherImageView.image = UIImage(named: "\((weatherModel?.condition)!)")
        conditionLabel.text = weatherModel?.conditionString
        tempCityLabel.text = "\((weatherModel?.temperature)!) °C"
        pressureLabel.text = "\((weatherModel?.pressureMm)!)"
        windSpeedLabel.text = "\((weatherModel?.windSpeed)!)"
        tempMinLabel.text = "\((weatherModel?.tempMin)!)"
        tempMaxLabel.text = "\((weatherModel?.tempMax)!)"
        
    }
    

}
