//
//  KeychainService.swift
//  WeatherApp
//
//  Created by Ecem Öztürk on 27.11.2023.
//

import Foundation
import Security

struct KeychainService {
    
    // Keychain service identifier
    private static let service = "YourAppService"
    
    // Keychain account identifier for storing API key
    private static let account = "APIKeyAccount"
    
    // Save the API key securely in the Keychain
    static func saveAPIKey(_ apiKey: String) {
        guard let data = apiKey.data(using: .utf8) else { return }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data
        ]
        
        // Remove any existing API key
        SecItemDelete(query as CFDictionary)
        
        // Add the new API key to the Keychain
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            print("Failed to save API key to Keychain")
        }
    }
    
    // Retrieve the API key from the Keychain
    static func getAPIKey() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess, let data = dataTypeRef as? Data, let apiKey = String(data: data, encoding: .utf8) {
            return apiKey
        } else {
            return nil
        }
    }
    
    // Delete the stored API key from the Keychain
    static func deleteAPIKey() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}
