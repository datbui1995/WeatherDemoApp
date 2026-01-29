//
//  City.swift
//  WeatherDemoApp
//
//  Created by Dat Bui on 29/1/26.
//

import Foundation

struct City: Codable, Equatable {
    let name: String
    let country: String
    let latitude: String
    let longitude: String
    let population: String
}

extension City {
    var displayedName: String {
        if country.isEmpty {
            return name
        }
        return "\(name), \(country)"
    }
}

extension City {
    init(entity: CityEntity) {
        self.init(
            name: entity.name,
            country: entity.country,
            latitude: entity.latitude,
            longitude: entity.longitude,
            population: entity.population
        )
    }
}
