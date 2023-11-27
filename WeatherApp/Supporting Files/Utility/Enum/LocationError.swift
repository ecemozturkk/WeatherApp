//
//  LocationError.swift
//  WeatherApp
//
//  Created by Ecem Öztürk on 27.11.2023.
//

import Foundation

enum LocationError: Error {
    case noLocationAvailable
    case noCityAvailable
    case noPlacemarkAvailable
}
