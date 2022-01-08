//
//  WeatherManager.swift
//  GoodWeather
//
//  Created by Игорь Павличенков on 17.12.2021.
//

import Foundation
import CoreLocation

class WeatherManager {
    
    let networkManager = NetworkManager()
    
    func getCoordinatesFrom (city: String, completion: @escaping(_ coordinates: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
        CLGeocoder().geocodeAddressString(city) { placemark, error in
            completion(placemark?.first?.location?.coordinate, error)
        }
        
    }
    
    func getCityWeather (name: String, completionHandler: @escaping (Weather?, Error?) -> Void) {
        
        getCoordinatesFrom(city: name) { [weak self] coordinates, error in
            guard let coordinates = coordinates, error == nil else {
                completionHandler(nil, error!)
                return
            }
            
            self?.networkManager.fetchWeather(name: name, latitude: coordinates.latitude, longitude: coordinates.longitude) { weather in
                completionHandler(weather, nil)
            }
        }
        
    }
    
}
