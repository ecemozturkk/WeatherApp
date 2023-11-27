//
//  Utility.swift
//  WeatherApp
//
//  Created by Ecem Öztürk on 26.11.2023.
//

import Foundation

class Utility {
        
    static func isTimeIntervalForToday(timeInterval: TimeInterval) -> Bool {
        // Get the current date and time
        let currentDate = Date()
        
        // Create a date from the given time interval
        let intervalDate = Date(timeIntervalSince1970: timeInterval)
        
        // Create a calendar and extract the date components
        let calendar = Calendar.current
        let currentDateComponents = calendar.dateComponents([.year, .month, .day], from: currentDate)
        let intervalDateComponents = calendar.dateComponents([.year, .month, .day], from: intervalDate)
        
        // Compare the date components
        return currentDateComponents.year == intervalDateComponents.year &&
        currentDateComponents.month == intervalDateComponents.month &&
        currentDateComponents.day == intervalDateComponents.day
    }
    
    static func getDateFromTimeStamp(timeStamp : Double, timeFormat: TimeFormat = .none) -> String {
        
        let date = NSDate(timeIntervalSince1970: timeStamp)
        
        let dayTimePeriodFormatter = DateFormatter()
        
        var dateFormat = ""
        switch timeFormat {
            
        case .timeOnly:
            dateFormat = "HH: mm"
        case .dateOnly:
            dateFormat = "MMM dd, YYYY"
        case .none:
            dateFormat = "EEEE, MMM dd, YYYY"
        }
        dayTimePeriodFormatter.dateFormat = dateFormat
        
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        
        return dateString
    }
    
    class func kelvinToCelsius(kelvin: Double) -> Double {
        let celsius = kelvin - 273.15
        return celsius
    }
    
}
