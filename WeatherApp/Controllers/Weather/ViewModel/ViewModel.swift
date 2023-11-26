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
    
    let networkService = NetworkService()
    
    var reloadWeatherList: (([WeekWeatherInfo]) -> Void)?
    var showWeatherData: ((WeatherData?) -> Void)?
    
    var weatherForeCastData = [WeekWeatherInfo]() {
        didSet {
            self.reloadWeatherList?(weatherForeCastData)
        }
    }
    
    var cityWeatherData: WeatherData? {
        didSet {
            if let weatherData = self.cityWeatherData {
                self.showWeatherData?(weatherData)
            }
        }
    }
    
    var cornerRadius: CGFloat {
        return 50.0
    }
    
    //MARK: - Helper Method(s)
    func getWeatherForeCastData() {
        networkService.getWeatherForcastData(cityName: "Istanbul,Turkey", completion: { status, data, msg in
            if status, let arrData = data {
                self.weatherForeCastData = arrData
            } else {
                print("Error: - \(msg ?? "NA")")
            }
        })
    }
    
    func getCityWeatherData() {
        networkService.getCityWeatherData(cityName: "Istanbul,Turkey", completion: { status, data, msg in
            if status, let weatherData = data {
                self.cityWeatherData = weatherData
            } else {
                print("Error: - \(msg ?? "NA")")
            }
        })
    }
    
    func downloadImage(from url: URL, completion: @escaping (UIImage) -> ()) {
        networkService.getDownloadUrl(from: url) { profileImage in
            completion(profileImage)
        }
    }
}
