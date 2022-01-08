//
//  NetworkManager.swift
//  GoodWeather
//
//  Created by Игорь Павличенков on 16.12.2021.
//

import Foundation

struct NetworkManager {
    
    func fetchWeather(name: String, latitude: Double, longitude: Double, completionHandler: @escaping (Weather) -> Void) {
        let urlString = "https://api.weather.yandex.ru/v2/forecast?lat=\(latitude)&lon=\(longitude)"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.addValue("\(apiKey)", forHTTPHeaderField: "X-Yandex-API-Key")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print (String(describing: error))
                return
            }
            if let weather = self.parseJSON(withData: data, name: name) {
                completionHandler(weather)
            }
        }
        
        task.resume()
    }
    
    func parseJSON(withData data: Data, name: String) -> Weather? {
        
        let decoder = JSONDecoder()
        do {
            let weatherData = try decoder.decode(WeatherData.self, from: data)
            guard var weather = Weather(weatherData: weatherData) else {
                return nil
            }
            weather.name = name
            return weather
        } catch let error as NSError {
            print(String(describing: error))
        }
        return nil
    }
    
}
