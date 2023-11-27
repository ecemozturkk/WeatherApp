//
//  NetworkServices.swift
//  WeatherApp
//
//  Created by Ecem Öztürk on 26.11.2023.
//

import Foundation
import UIKit

protocol NetworlServiceProtocol {
    func getWeatherForcastData(cityName: String, completion: @escaping (Bool, [WeekWeatherInfo]?, String?) -> ())
    func getCityWeatherData(cityName: String, completion: @escaping (Bool, WeatherData?, String?) -> ())
}

class NetworkService {
    
    func getWeatherForcastData(cityName: String, completion: @escaping (Bool, [WeekWeatherInfo]?, String?) -> ()) {
        
        NetworkHelper.shared.GET(url: "https://api.openweathermap.org/data/2.5/forecast", params: ["q": "\(cityName)", "appid": Constant.OW_API_KEY], httpHeader: .none) { success, data in
            if success {
                do {
                    let model = try JSONDecoder().decode(WeatherResponse.self, from: data!)
                    completion(true, model.list, nil)
                } catch {
                    completion(false, nil, "Error: Trying to parse Employees to model")
                }
            } else {
                completion(false, nil, "Error: Employees GET Request failed")
            }
        }
    }
    
    func getCityWeatherData(cityName: String, completion: @escaping (Bool, WeatherData?, String?) -> ()) {
        NetworkHelper.shared.GET(url: "https://api.openweathermap.org/data/2.5/weather", params: ["q": "\(cityName)", "appid": Constant.OW_API_KEY], httpHeader: .none) { success, data in
            if success {
                do {
                    let model = try JSONDecoder().decode(WeatherData.self, from: data!)
                    completion(true, model, nil)
                } catch {
                    completion(false, nil, "Error: Trying to parse Employees to model")
                }
            } else {
                completion(false, nil, "Error: Employees GET Request failed")
            }
        }
    }
    
    func getDownloadUrl(from url: URL, completion: @escaping (UIImage) -> ()) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error downloading image: \(error)")
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }.resume()
    }
    
}
