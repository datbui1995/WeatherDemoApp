//
//  Weather.swift
//  WeatherDemoApp
//
//  Created by Dat Bui on 29/1/26.
//

import Foundation

struct WeatherResponse: Codable, Equatable {
    let data: WeatherData
}

struct WeatherData: Codable, Equatable {
    let currentCondition: [CurrentCondition]
    
    private enum CodingKeys: String, CodingKey {
        case currentCondition = "current_condition"
    }
}

struct CurrentCondition: Codable, Equatable {
    let imageURL: [StringValueResponse]
    let description: [StringValueResponse]
    let temperature: String
    let humidity: String
    
    private enum CodingKeys: String, CodingKey {
        case imageURL = "weatherIconUrl"
        case description = "weatherDesc"
        case temperature = "temp_C"
        case humidity = "humidity"
    }
}

extension WeatherResponse {
    func toCurrentWeather() -> CurrentWeather {
        guard let currentCondition = data.currentCondition.first else { return .empty }
        return .init(imageURL: currentCondition.imageURL.firstValue,
                     description: currentCondition.description.firstValue,
                     temperature: currentCondition.temperature,
                     humidity: currentCondition.humidity)
    }
}
