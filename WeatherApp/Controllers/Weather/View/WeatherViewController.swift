//
//  ViewController.swift
//  WeatherApp
//
//  Created by Ecem Öztürk on 26.11.2023.
//

import UIKit

class WeatherViewController: UIViewController {
    
    //MARK: - IBOutlet(s)
    
    @IBOutlet weak var lblDate: UILabel?
    @IBOutlet weak var lblCity: UILabel?
    @IBOutlet weak var lblWeatherDescription: UILabel?
    @IBOutlet weak var imgWeatherStatusPic: UIImageView?
    @IBOutlet weak var btnForecastSegment: UISegmentedControl?
    @IBOutlet weak var weatherCollectionViewList: UICollectionView?
    @IBOutlet weak var btnTempSegment: UISegmentedControl!

    //MARK: - Var(s)
    
    lazy var viewModel = {
        WeatherViewModel()
    }()
    
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
    
    @IBAction func btnSegmentAction(_ segment: UISegmentedControl) {
        self.weatherCollectionViewList?.reloadData()
    }
        
    @IBAction func btnTempSegmentAction(_ segment: UISegmentedControl) {
        tempBool = (segment.selectedSegmentIndex == 0)
        self.weatherCollectionViewList?.reloadData()
    }
    
    @IBAction func onSearch(_ sender: Any) {
        // Create an alert controller
        let alertController = UIAlertController(title: "Search", message: "Enter your city", preferredStyle: .alert)

        // Add a text field to the alert controller
        alertController.addTextField { (textField) in
            textField.placeholder = "City"
        }

        // Create the search action
        let searchAction = UIAlertAction(title: "Search", style: .default) { [weak self] (_) in
            if let textField = alertController.textFields?.first, let searchText = textField.text {
                // Handle the search here, e.g., perform a search with searchText
                
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
    
    func performSearch(with cityName: String) {
        
        self.viewModel.getWeatherForeCastData(city: cityName)
        self.viewModel.getCityWeatherData(city: cityName)
        
    }
    
    
}

//MARK: - UI update and ViewModel Initializer

extension WeatherViewController {
    
    func initViewModel() {
        
        viewModel.reloadWeatherList = { [weak self] arrData in
            DispatchQueue.main.async {
                self?.updateForeCastList(arrForeCastData: arrData)
            }
        }
        
        viewModel.showWeatherData = { [weak self] cityData in
            if let cityData = cityData {
                self?.currentWeatherData = cityData
            }
            DispatchQueue.main.async {
                self?.showCityWeatherData()
            }
        }
        
        
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
    
    func updateForeCastList(arrForeCastData: [WeekWeatherInfo]) {
        self.weekForecast = arrForeCastData.filter({ Utility.isTimeIntervalForToday(timeInterval: $0.dt ?? .zero) == false })
        self.todayForeCast = arrForeCastData.filter({ Utility.isTimeIntervalForToday(timeInterval: $0.dt ?? .zero) == true  })
        self.weatherCollectionViewList?.reloadData()
    }
    
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
            let celsiusTemperature: Double = tempInCelsius
            let fahrenheitTemperature = celsiusToFahrenheit(celsiusTemperature)

            cell.lblTemprature?.text = tempBool ? String(format: "%.2f °C", tempInCelsius) : String(format: "%.2f °F", fahrenheitTemperature)
            
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
    // EKLENECEK AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
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
        return (celsius * 9/5) + 32
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





