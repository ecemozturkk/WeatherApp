//
//  Utility.swift
//  WeatherApp
//
//  Created by Ecem Öztürk on 26.11.2023.
//

import Foundation

class Utility {
    
    // Check if the given time interval corresponds to today
    static func isTimeIntervalForToday(timeInterval: TimeInterval) -> Bool {
        let currentDate = Date()
        let intervalDate = Date(timeIntervalSince1970: timeInterval)
        let calendar = Calendar.current
        let currentDateComponents = calendar.dateComponents([.year, .month, .day], from: currentDate)
        let intervalDateComponents = calendar.dateComponents([.year, .month, .day], from: intervalDate)
        
        return currentDateComponents.year == intervalDateComponents.year &&
        currentDateComponents.month == intervalDateComponents.month &&
        currentDateComponents.day == intervalDateComponents.day
    }
    
    // Get a formatted date string from a given timestamp
    static func getDateFromTimeStamp(timeStamp: Double, timeFormat: TimeFormat = .none) -> String {
        let date = NSDate(timeIntervalSince1970: timeStamp)
        let dayTimePeriodFormatter = DateFormatter()
        
        var dateFormat = ""
        switch timeFormat {
        case .timeOnly:
            dateFormat = "HH:mm"
        case .dateOnly:
            dateFormat = "MMM dd, yyyy"
        case .none:
            dateFormat = "EEEE, MMM dd, yyyy"
        }
        dayTimePeriodFormatter.dateFormat = dateFormat
        
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        
        return dateString
    }
    
    // Convert temperature from Kelvin to Celsius
    class func kelvinToCelsius(kelvin: Double) -> Double {
        let celsius = kelvin - 273.15
        return celsius
    }
}
