//
//  CityResponse.swift
//  WeatherDemoApp
//
//  Created by Dat Bui on 29/1/26.
//

import Foundation

struct SearchCityResponse: Codable, Equatable {
    let searchAPI: SearchAPI
    
    enum CodingKeys: String, CodingKey {
        case searchAPI = "search_api"
    }
}

struct SearchAPI: Codable, Equatable {
    let cities: [CityResponse]
    
    enum CodingKeys: String, CodingKey {
        case cities = "result"
    }
}

struct CityResponse: Codable, Equatable {
    let areaName: [StringValueResponse]
    let country: [StringValueResponse]
    let weatherUrl: [StringValueResponse]
    let latitude: String
    let longitude: String
    let population: String
}

struct StringValueResponse: Codable, Equatable {
    let value: String
    enum CodingKeys: String, CodingKey {
        case value
    }
}

extension CityResponse {
    func toDomain() -> City {
        City(
            name: areaName.first?.value ?? "",
            country: country.first?.value ?? "",
            latitude: latitude,
            longitude: longitude,
            population: population
        )
    }
}
