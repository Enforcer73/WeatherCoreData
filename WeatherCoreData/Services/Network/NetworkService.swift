//
//  NetworkService.swift
//  WeatherCoreData
//
//  Created by Ruslan Bagautdinov on 02.03.2022.
//  Copyright © 2022 Ruslan Bagautdinov. All rights reserved.
//

import Foundation

final class NetworkService {

    let group = DispatchGroup()
    static let shared = NetworkService()

    init() {}
//cities: [String], completion: @escaping (WeatherCity) -> Void

    //MARK: = Transform URLString

    func transformURLString(_ string: String) -> URLComponents? {
        guard let urlPath = string.components(separatedBy: "?").first else { return nil }

        var components = URLComponents(string: urlPath)

        if let queryString = string.components(separatedBy: "?").last {
            components?.queryItems = []

            let queryItems = queryString.components(separatedBy: "&")

            for queryItem in queryItems {
                guard let itemName = queryItem.components(separatedBy: "=").first,
                      let itemValue = queryItem.components(separatedBy: "=").last else { continue }

                components?.queryItems?.append(URLQueryItem(name: itemName, value: itemValue))
            }
        }
        guard let components = components else { return nil }
        return components
    }

    //MARK: - Requesting weather data with city names

    func getWeather(cities: String, completion: @escaping (WeatherCity) -> Void) {
        
        let apiKey = "f5e098d42031e8a0a95e2c6c477f846d"
        
        let urlStr = "https://api.openweathermap.org/data/2.5/weather?q=\(cities)&lang=ru&units=metric&appid=\(apiKey)"
        
        let urlTransform = transformURLString(urlStr)
        guard let url = urlTransform?.url else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data else {
                print(String(describing: error))
                return}
            
//            print(String(data: data, encoding: .utf8)!)
            
            do {
                let weatherData = try JSONDecoder().decode(WeatherCityModel.self, from: data)
                
                guard let weather = WeatherCity(weatherData: weatherData) else { return }
                completion(weather)
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    //MARK: - Get request weather data with coordinate

//    func getWeatherData(latitude: Double, longitude: Double, completion: @escaping (Weather) -> Void) {
//
//        let apiKey = "f5e098d42031e8a0a95e2c6c477f846d"
//
//        let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&lang=ru&units=metric&appid=\(apiKey)"
//
//        guard let url = URL(string: url) else { return }
//
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data else {
//                print(String(describing: error))
//                return
//            }
//            print(String(data: data, encoding: .utf8)!)
//            
//            do {
//                let weatherData = try JSONDecoder().decode(WeatherModel.self, from: data)
//
//                guard let weather = Weather(weatherData: weatherData) else { return }
//
//                completion(weather)
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//        task.resume()
//    }
}
