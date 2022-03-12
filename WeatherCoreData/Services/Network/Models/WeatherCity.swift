//
//  WeatherCity.swift
//  WeatherCoreData
//
//  Created by Ruslan Bagautdinov on 06.03.2022.
//  Copyright © 2022 Ruslan Bagautdinov. All rights reserved.
//

import Foundation

class WeatherCity {
    var nameCity: String = ""
    var icon: String = ""
    var description: String = ""
    
    var temp: Double = ceil(0.0)
    var tempStr: String {
        return String(format: "%.0f", temp)
    }
    var tempMin: Double = ceil(0.0)
    var tempMinStr: String {
        return String(format: "%.0f", tempMin)
    }
    var tempMax: Double = ceil(0.0)
    var tempMaxStr: String {
        return String(format: "%.0f", tempMax)
    }
    var humidity: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case icon, description, temp, humidity
        case nameCity = "name"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
    
    init?(weatherData: WeatherCityModel) {
        nameCity = weatherData.name ?? ""
        icon = weatherData.weather?.first?.icon ?? ""
        description = weatherData.weather?.first?.weatherDescription ?? ""
        temp = weatherData.main?.temp ?? 0.0
        tempMin = weatherData.main?.tempMin ?? 0.0
        tempMax = weatherData.main?.tempMax ?? 0.0
        humidity = weatherData.main?.humidity ?? 0
    }
    
    init(){
    }
}
