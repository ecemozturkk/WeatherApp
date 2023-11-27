//
//  CacheManager.swift
//  WeatherApp
//
//  Created by Ecem Öztürk on 27.11.2023.
//

import Foundation

class CacheManager {
    
    // Singleton instance of CacheManager
    public static let shared = CacheManager()
    // UserDefaults instance for data persistence
    private let userDefaults = UserDefaults.standard
    // Private initializer for Singleton pattern
    private init() {}
    
    // Save weekly weather forecast data for a specific city to UserDefaults
    func saveWeatherForcastData(cityName: String, data: [WeekWeatherInfo]) {
        do {
            let encodedData = try JSONEncoder().encode(data)
            userDefaults.set(encodedData, forKey: "WeatherForcast_\(cityName)")
        } catch {
            print("Error encoding WeatherForcast data: \(error.localizedDescription)")
        }
    }
    
    // Retrieve cached weekly weather forecast data for a specific city from UserDefaults
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
    
    // Save current city weather data to UserDefaults
    func saveCityWeatherData(cityName: String, data: WeatherData) {
        do {
            let encodedData = try JSONEncoder().encode(data)
            userDefaults.set(encodedData, forKey: "CityWeather_\(cityName)")
        } catch {
            print("Error encoding CityWeather data: \(error.localizedDescription)")
        }
    }
    
    // Retrieve cached current city weather data from UserDefaults
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

