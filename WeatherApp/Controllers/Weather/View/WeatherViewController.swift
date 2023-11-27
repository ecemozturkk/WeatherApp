//
//  ViewController.swift
//  WeatherApp
//
//  Created by Ecem Öztürk on 26.11.2023.
//

import UIKit

class WeatherViewController: UIViewController {
    
    //MARK: - IBOutlet(s)
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblCity: UILabel?
    @IBOutlet weak var lblWeatherDescription: UILabel!
    @IBOutlet weak var imgWeatherStatusPic: UIImageView?
    @IBOutlet weak var btnForecastSegment: UISegmentedControl?
    @IBOutlet weak var weatherCollectionViewList: UICollectionView?
    @IBOutlet weak var btnTempSegment: UISegmentedControl!
    @IBOutlet weak var temperature: UILabel!
    
    //MARK: - Var(s)
    
    // Lazy instantiation of the WeatherViewModel
    lazy var viewModel = {
        WeatherViewModel()
    }()
    
    // Weekly and daily weather forecasts, current weather, and location manager
    var weekForecast: [WeekWeatherInfo] = []
    var todayForeCast: [WeekWeatherInfo] = []
    var currentWeatherData: WeatherData?
    let cityManager = LocationManager.shared
    
    var tempBool = true
    
    //MARK: - Life Cycle Method(s)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initViewModel()
        
        weatherCollectionViewList?.dataSource = self
        weatherCollectionViewList?.delegate = self
    }
    
    //MARK: - Action Method(s)
    
    // btnSegmentAction: Handles the segmented control for forecast selection
    @IBAction func btnSegmentAction(_ segment: UISegmentedControl) {
        self.weatherCollectionViewList?.reloadData()
    }
    
    // btnTempSegmentAction: Handles the segmented control for temperature unit selection
    @IBAction func btnTempSegmentAction(_ segment: UISegmentedControl) {
        tempBool = (segment.selectedSegmentIndex == 0)
        self.weatherCollectionViewList?.reloadData()
        
        if let temperatureValue = self.currentWeatherData?.main.temp {
            let celsiusTemperature = Utility.kelvinToCelsius(kelvin: temperatureValue)
            let fahrenheitTemperature = celsiusToFahrenheit(celsiusTemperature)
            self.temperature?.text = tempBool ? String(format: "%.0f °C", celsiusTemperature) : String(format: "%.0f °F", fahrenheitTemperature)
        }
    }
    
    // onSearch: Displays an alert for city search
    @IBAction func onSearch(_ sender: Any) {
        // Create an alert controller
        let alertController = UIAlertController(title: "Search", message: "Enter a city name", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "City"
        }
        
        let searchAction = UIAlertAction(title: "Search", style: .default) { [weak self] (_) in
            if let textField = alertController.textFields?.first, let searchText = textField.text {
                if(!searchText.isEmpty) {
                    self?.performSearch(with: searchText)
                }
            }
        }
        
        // Create the cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // Add the actions to the alert controller
        alertController.addAction(searchAction)
        alertController.addAction(cancelAction)
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }
    
    // performSearch: Initiates a weather search for the specified city
    func performSearch(with cityName: String) {
        self.viewModel.getWeatherForeCastData(city: cityName)
        self.viewModel.getCityWeatherData(city: cityName)
    }
    
    // updateTemperatureLabel: Updates the temperature label based on the selected unit
    func updateTemperatureLabel() {
        if let temperatureValue = self.currentWeatherData?.main.temp {
            let celsiusTemperature = Utility.kelvinToCelsius(kelvin: temperatureValue)
            
            let roundedTemperature = tempBool ? round(celsiusTemperature) : round(celsiusToFahrenheit(celsiusTemperature))
            
            self.temperature?.text = String(format: "%.0f °%@", roundedTemperature, tempBool ? "C" : "F")
        }
    }
    
    // convertTemperature: Converts temperature from Celsius to Fahrenheit if needed
    func convertTemperature(_ celsius: Double) -> String {
        let roundedTemperature = round(celsius)
        return tempBool ? String(format: "%.0f °C", roundedTemperature) : String(format: "%.0f °F", celsiusToFahrenheit(roundedTemperature))
    }
}

//MARK: - UI update and ViewModel Initializer

extension WeatherViewController {
    
    func initViewModel() {
        // Callback to update the weather forecast list
        viewModel.reloadWeatherList = { [weak self] arrData in
            DispatchQueue.main.async {
                self?.updateForeCastList(arrForeCastData: arrData)
            }
        }
        
        // Callback to show the current weather data
        viewModel.showWeatherData = { [weak self] cityData in
            if let cityData = cityData {
                self?.currentWeatherData = cityData
            }
            DispatchQueue.main.async {
                self?.showCityWeatherData()
            }
        }
        
        // Fetches the current city using the location manager
        cityManager.getCurrentCity { result in
            switch result {
            case .success(let cityName):
                self.viewModel.getWeatherForeCastData(city: cityName)
                self.viewModel.getCityWeatherData(city: cityName)
            case .failure(let error):
                print("Error getting city name: \(error)")
            }
        }
    }
    
    // updateForeCastList: Updates the forecast data arrays based on the retrieved data
    func updateForeCastList(arrForeCastData: [WeekWeatherInfo]) {
        self.weekForecast = arrForeCastData.filter({ Utility.isTimeIntervalForToday(timeInterval: $0.dt ?? .zero) == false })
        self.todayForeCast = arrForeCastData.filter({ Utility.isTimeIntervalForToday(timeInterval: $0.dt ?? .zero) == true  })
        self.weatherCollectionViewList?.reloadData()
    }
    
    // showCityWeatherData: Updates the UI elements with the current weather data
    func showCityWeatherData() {
        if let timeInterval = self.currentWeatherData?.dt {
            self.lblDate?.text = Utility.getDateFromTimeStamp(timeStamp: timeInterval)
        } else {
            self.lblDate?.text = "NA"
        }
        
        if let description = self.currentWeatherData?.weather.first?.description {
            self.lblWeatherDescription?.text = description
        } else {
            self.lblWeatherDescription?.text = "NA"
        }
        
        if let city = self.currentWeatherData?.name {
            self.lblCity?.text = city
        } else {
            self.lblCity?.text = "NA"
        }
        
        if let temperature = self.currentWeatherData?.main.temp {
            let celsiusTemperature = Utility.kelvinToCelsius(kelvin: temperature)
            let fahrenheitTemperature = celsiusToFahrenheit(celsiusTemperature)
            self.temperature?.text = tempBool ? String(format: "%.2f °C", celsiusTemperature) : String(format: "%.2f °F", fahrenheitTemperature)
            
            updateTemperatureLabel()
        } else {
            self.temperature?.text = "NA"
        }
        
        if let iconName = self.currentWeatherData?.weather.first?.icon, let icon = UIImage(named: iconName) {
            self.imgWeatherStatusPic?.image = icon
        } else {
            self.imgWeatherStatusPic?.image = UIImage(named: "unknown")
        }
    }
}

//MARK: - UICollectionViewDataSource Method(s)

extension WeatherViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.btnForecastSegment?.selectedSegmentIndex == 0 ? self.todayForeCast.count : self.weekForecast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherForecastCell", for: indexPath) as! WeatherForecastCell
        
        let currentListArray = self.btnForecastSegment?.selectedSegmentIndex == 0 ? self.todayForeCast : self.weekForecast
        
        let data = currentListArray[indexPath.row]
        
        if let iconName = data.weather.first?.icon, let icon = UIImage(named: iconName) {
            cell.imgWeatherStatusPic?.image = icon
        } else {
            cell.imgWeatherStatusPic?.image = UIImage(named: "unknown")
        }
        
        if let tempInKelvin = data.main.temp {
            let tempInCelsius = Utility.kelvinToCelsius(kelvin: tempInKelvin)
            cell.lblTemprature?.text = convertTemperature(tempInCelsius)
        } else {
            cell.lblTemprature?.text = "NA"
        }
        
        if let timeInterval = data.dt {
            cell.lblTime?.text = self.btnForecastSegment?.selectedSegmentIndex == 0 ? Utility.getDateFromTimeStamp(timeStamp: timeInterval, timeFormat: .timeOnly) : Utility.getDateFromTimeStamp(timeStamp: timeInterval)
        } else {
            cell.lblTime?.text = "NA"
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentListArray = self.btnForecastSegment?.selectedSegmentIndex == 0 ? self.todayForeCast : self.weekForecast
        
        let data = currentListArray[indexPath.row]
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "WeatherDetailViewController" ) as! WeatherDetailViewController
        vc.weekForecast = data
        vc.currentWeatherData = currentWeatherData
        vc.tempBool = tempBool
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func celsiusToFahrenheit(_ celsius: Double) -> Double {
        return round((celsius * 9/5) + 32)
    }
}

//MARK: - //MARK: - UICollectionViewDataSource Method(s)

extension WeatherViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let colllectionViewHeight = collectionView.bounds.size.height
        let colllectionViewWidth = collectionView.bounds.size.width / 5
        return CGSize(width: colllectionViewWidth, height: colllectionViewHeight)
    }
}
