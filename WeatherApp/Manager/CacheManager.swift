//
//  CacheManager.swift
//  WeatherApp
//
//  Created by Ecem Öztürk on 27.11.2023.
//

import Foundation

class CacheManager {
    
    public static let shared = CacheManager()
    private let userDefaults = UserDefaults.standard
    
    private init() {}
    
    func saveWeatherForcastData(cityName: String, data: [WeekWeatherInfo]) {
        do {
            let encodedData = try JSONEncoder().encode(data)
            userDefaults.set(encodedData, forKey: "WeatherForcast_\(cityName)")
        } catch {
            print("Error encoding WeatherForcast data: \(error.localizedDescription)")
        }
    }
    
    func getCacheWeatherForcastData(cityName: String) -> [WeekWeatherInfo]? {
        if let encodedData = userDefaults.data(forKey: "WeatherForcast_\(cityName)") {
            do {
                let decodedData = try JSONDecoder().decode([WeekWeatherInfo].self, from: encodedData)
                return decodedData
            } catch {
                print("Error decoding WeatherForcast data: \(error.localizedDescription)")
            }
        }
        return nil
    }
    
    func saveCityWeatherData(cityName: String, data: WeatherData) {
        do {
            let encodedData = try JSONEncoder().encode(data)
            userDefaults.set(encodedData, forKey: "CityWeather_\(cityName)")
        } catch {
            print("Error encoding CityWeather data: \(error.localizedDescription)")
        }
    }
    
    func getCacheCityWeatherData(cityName: String) -> WeatherData? {
        if let encodedData = userDefaults.data(forKey: "CityWeather_\(cityName)") {
            do {
                let decodedData = try JSONDecoder().decode(WeatherData.self, from: encodedData)
                return decodedData
            } catch {
                print("Error decoding CityWeather data: \(error.localizedDescription)")
            }
        }
        return nil
    }
}
