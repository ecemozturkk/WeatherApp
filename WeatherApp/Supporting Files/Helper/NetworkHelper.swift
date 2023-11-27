//
//  NetworkHelper.swift
//  WeatherApp
//
//  Created by Ecem Öztürk on 26.11.2023.
//

import Foundation

class NetworkHelper {
    
    // Singleton instance of NetworkHelper
    static let shared = NetworkHelper()
    
    // Private initializer to enforce singleton pattern
    private init(){}
    
    // Performs a GET request with specified parameters and headers
    func GET(url: String, params: [String: String], httpHeader: HTTPHeaderFields, complete: @escaping (Bool, Data?) -> ()) {
        // Create URLComponents from the given URL
        guard var components = URLComponents(string: url) else {
            print("Error: cannot create URLCompontents")
            return
        }
        // Map the parameters to URLQueryItems
        components.queryItems = params.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        // Create URL from the components
        guard let url = components.url else {
            print("Error: cannot create URL")
            return
        }
        
        // Create a URLRequest with the URL and set the HTTP method to GET
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Set the content type header based on the specified HTTP header
        switch httpHeader {
        case .application_json:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        case .application_x_www_form_urlencoded:
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        case .none: break
        }
        
        // Create an ephemeral URLSession configuration to prevent caching
        let config = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: config)
        
        // Perform a data task with the created request
        session.dataTask(with: request) { data, response, error in
            // Check for errors and handle accordingly
            guard error == nil else {
                print("Error: problem calling GET")
                print(error!)
                complete(false, nil)
                return
            }
            // Check if data was received
            guard let data = data else {
                print("Error: did not receive data")
                complete(false, nil)
                return
            }
            // Check if the HTTP response status code is in the success range
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                print("Error: HTTP request failed")
                complete(false, nil)
                return
            }
            // Call the completion handler with success status and data
            complete(true, data)
        }.resume()
    }
}
