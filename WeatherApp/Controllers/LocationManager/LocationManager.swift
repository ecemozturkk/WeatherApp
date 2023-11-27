//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Ecem Öztürk on 27.11.2023.
//

import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    // Singleton instance
    static let shared = LocationManager()
    
    private var locationManager: CLLocationManager
    private var completion: ((Result<String, Error>) -> Void)?
    
    // Private initializer for Singleton pattern
    private override init() {
        self.locationManager = CLLocationManager()
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    // Request and retrieve the current city based on the user's location.
    func getCurrentCity(completion: @escaping (Result<String, Error>) -> Void) {
        self.completion = completion
        self.locationManager.startUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    
    // Handle location updates and reverse geocode to get the current city.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            completion?(.failure(LocationError.noLocationAvailable))
            return
        }
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                self.completion?(.failure(error))
            } else if let placemark = placemarks?.first {
                if let city = placemark.locality {
                    self.completion?(.success(city))
                } else {
                    self.completion?(.failure(LocationError.noCityAvailable))
                }
            } else {
                self.completion?(.failure(LocationError.noPlacemarkAvailable))
            }
        }
        self.locationManager.stopUpdatingLocation()
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        completion?(.failure(error))
    }
}

