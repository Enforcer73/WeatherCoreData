//
//  GetCityWeather.swift
//  WeatherCoreData
//
//  Created by Ruslan Bagautdinov on 02.03.2022.
//  Copyright © 2022 Ruslan Bagautdinov. All rights reserved.
//
import UIKit
import Foundation
import CoreLocation

final class GetCityCoordinate {

    let networkService = NetworkService.shared.self
    
    //MARK: - Fetching city name

    func movingCootdinateToReques(cityesArray: [String], comletionHandler: @escaping (Int, WeatherCity) -> Void) {
        
        //MARK: - Search witc city name

        for (index, city) in cityesArray.enumerated() {
            
            self.networkService.getWeather(cities: city) { weather in
                comletionHandler(index, weather)
            }
        }
    }
        
        //MARK: - Search witc city coordinate

//        for (index, item) in cityesArray.enumerated() {
//            getCityCoordinate(city: item) { [weak self] coordinate, error in
//
//                guard let coordinate = coordinate, error == nil else { return }
//
//                //MARK: - Adding city coordinate in URL
//
//                self?.networkService.getWeatherData(latitude: coordinate.latitude, longitude: coordinate.longitude) { weather in
//                    comletionHandler(index, weather)
//                }
//            }
//        }
//    }

    //MARK: - Fetching city cootdinate

    func getCityCoordinate(city: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> ()) {
        
        CLGeocoder().geocodeAddressString(city) { placemark, error in
            completion(placemark?.first?.location?.coordinate, error)
        }
    }
}
