//
//  WeatherDetailViewController.swift
//  WeatherApp
//
//  Created by Ecem Öztürk on 27.11.2023.
//

import UIKit

class WeatherDetailViewController: UIViewController {
    
    @IBOutlet weak var weatherStatusImageView: UIImageView!
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
        setupUI()
    }
    // Set up the user interface with weather information.
        func setupUI() {
            // Display current temperature in Celsius or Fahrenheit based on user preference.
            if let tempInKelvin = weekForecast?.main.temp {
                let tempInCelsius = Utility.kelvinToCelsius(kelvin: tempInKelvin)
                let celsiusTemperature = Int(tempInCelsius)
                let fahrenheitTemperature = Int(celsiusToFahrenheit(Double(celsiusTemperature)))
                
                self.lblTemp?.text = tempBool ? "\(celsiusTemperature) °C" : "\(fahrenheitTemperature) °F"
                self.lblhumidity?.text = String(weekForecast?.main.humidity ?? 0)
            }
            
            // Display minimum temperature.
            if let tempInKelvin = weekForecast?.main.temp_min {
                let tempInCelsius = Utility.kelvinToCelsius(kelvin: tempInKelvin)
                let celsiusTemperature = Int(tempInCelsius)
                let fahrenheitTemperature = Int(celsiusToFahrenheit(Double(celsiusTemperature)))
                
                self.lblMinTemp?.text = tempBool ? "\(celsiusTemperature) °C" : "\(fahrenheitTemperature) °F"
            }
            
            // Display maximum temperature.
            if let tempInKelvin = weekForecast?.main.temp_max {
                let tempInCelsius = Utility.kelvinToCelsius(kelvin: tempInKelvin)
                let celsiusTemperature = Int(tempInCelsius)
                let fahrenheitTemperature = Int(celsiusToFahrenheit(Double(celsiusTemperature)))
                
                self.lblMaxTemp?.text = tempBool ? "\(celsiusTemperature) °C" : "\(fahrenheitTemperature) °F"
            }
            
            // Display weather description or "NA" if not available.
            if let description = self.currentWeatherData?.weather.first?.description {
                self.lblDescription?.text = description
            } else {
                self.lblDescription?.text = "NA"
            }
            
            // Display weather icon or default "unknown" if not available.
            if let iconName = weekForecast?.weather.first?.icon, let icon = UIImage(named: iconName) {
                self.weatherStatusImageView?.image = icon
            } else {
                self.weatherStatusImageView?.image = UIImage(named: "unknown")
            }
            
            // Display date or "NA" if not available.
            if let date = weekForecast?.dt {
                self.lblDate.text = Utility.getDateFromTimeStamp(timeStamp: date)
            } else {
                self.lblDate.text = "NA"
            }
        }
        
        // Convert temperature from Celsius to Fahrenheit.
        func celsiusToFahrenheit(_ celsius: Double) -> Double {
            return (celsius * 9/5) + 32
        }
    }
