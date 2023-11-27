//
//  ViewModel.swift
//  WeatherApp
//
//  Created by Ecem Öztürk on 26.11.2023.
//

import Foundation
import UIKit

class WeatherViewModel {
    
    //MARK: - Var(s)
    
    // Network service instance for making API requests
    let networkService = NetworkService()
    
    // Callbacks to notify the UI when data updates
    var reloadWeatherList: (([WeekWeatherInfo]) -> Void)?
    var showWeatherData: ((WeatherData?) -> Void)?
    
    // Data sources for weather information
    var weatherForeCastData = [WeekWeatherInfo]() {
        didSet {
            // Trigger UI update when weekly weather forecast data is set
            self.reloadWeatherList?(weatherForeCastData)
        }
    }
    
    var cityWeatherData: WeatherData? {
        didSet {
            // Trigger UI update when current city weather data is set
            if let weatherData = self.cityWeatherData {
                self.showWeatherData?(weatherData)
            }
        }
    }
    
    //MARK: - Helper Method(s)
    // Fetch weekly weather forecast data for a specific city
    func getWeatherForeCastData(city: String) {
        networkService.getWeatherForcastData(cityName: city, completion: { status, data, msg in
            if status, let arrData = data {
                self.weatherForeCastData = arrData
            } else {
                print("Error: - \(msg ?? "NA")")
            }
        })
    }
    
    // Fetch current weather data for a specific city
    func getCityWeatherData(city: String) {
        networkService.getCityWeatherData(cityName: city, completion: { status, data, msg in
            if status, let weatherData = data {
                self.cityWeatherData = weatherData
            } else {
                print("Error: - \(msg ?? "NA")")
            }
        })
    }
}
