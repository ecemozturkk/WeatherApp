//
//  Constant.swift
//  WeatherApp
//
//  Created by Ecem Öztürk on 26.11.2023.
//

import Foundation

struct Constant {
    static let mainStorybaord = "Main"
    
    static var OW_API_KEY: String {
        get {
            if let storedKey = KeychainService.getAPIKey() {
                return storedKey
            } else {
                return "555707b60a648234521b877ef252df72"
            }
        }
        set {
            KeychainService.saveAPIKey(newValue)
        }
    }
}
