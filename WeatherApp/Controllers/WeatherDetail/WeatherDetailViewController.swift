//
//  WeatherDetailViewController.swift
//  WeatherApp
//
//  Created by Ecem Öztürk on 27.11.2023.
//

import UIKit

class WeatherDetailViewController: UIViewController {
    
    @IBOutlet weak var imgWeatherStatusPic: UIImageView!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var lblMaxTemp: UILabel!
    @IBOutlet weak var lblMinTemp: UILabel!
    @IBOutlet weak var lblhumidity: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    var weekForecast : WeekWeatherInfo?
    var currentWeatherData: WeatherData?
    
    var tempBool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tempInKelvin = weekForecast?.main.temp {
            let tempInCelsius = Utility.kelvinToCelsius(kelvin: tempInKelvin)
            let celsiusTemperature = Int(tempInCelsius)
            let fahrenheitTemperature = Int(celsiusToFahrenheit(Double(celsiusTemperature)))

            self.lblTemp?.text = tempBool ? "\(celsiusTemperature) °C" : "\(fahrenheitTemperature) °F"
            self.lblhumidity?.text = String(weekForecast?.main.humidity ?? 0)
        }
                
        if let tempInKelvin = weekForecast?.main.temp_min {
            let tempInCelsius = Utility.kelvinToCelsius(kelvin: tempInKelvin)
            let celsiusTemperature: Double = tempInCelsius
            let fahrenheitTemperature = celsiusToFahrenheit(celsiusTemperature)
            
            self.lblMinTemp?.text = tempBool ? String(format: "%.2f °C", tempInCelsius) : String(format: "%.2f °F", fahrenheitTemperature)
        }
        
        if let tempInKelvin = weekForecast?.main.temp_max {
            let tempInCelsius = Utility.kelvinToCelsius(kelvin: tempInKelvin)
            let celsiusTemperature: Double = tempInCelsius
            let fahrenheitTemperature = celsiusToFahrenheit(celsiusTemperature)
            
            self.lblMaxTemp?.text = tempBool ? String(format: "%.2f °C", tempInCelsius) : String(format: "%.2f °F", fahrenheitTemperature)
        }
        
        if let description = self.currentWeatherData?.weather.first?.description {
            self.lblDescription?.text = description
        } else {
            self.lblDescription?.text = "NA"
        }
        
        if let iconName = weekForecast?.weather.first?.icon, let icon = UIImage(named: iconName) {
            self.imgWeatherStatusPic?.image = icon
        } else {
            self.imgWeatherStatusPic?.image = UIImage(named: "unknown")
        }
        
        if let date = weekForecast?.dt {
            self.lblDate.text = Utility.getDateFromTimeStamp(timeStamp: date)
        } else {
            self.lblDate.text = "NA"
        }
    }
    
    func celsiusToFahrenheit(_ celsius: Double) -> Double {
        return (celsius * 9/5) + 32
    }
    
}

