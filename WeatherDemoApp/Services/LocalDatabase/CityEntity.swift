//
//  CityEntity.swift
//  WeatherDemoApp
//
//  Created by Dat Bui on 29/1/26.
//

import Foundation
import SwiftData

@Model
final class CityEntity {
    @Attribute(.unique) var id: String
    var name: String
    var country: String
    var latitude: String
    var longitude: String
    var population: String
    var createdAt: Date
    
    init(
        id: String = UUID().uuidString,
        name: String,
        country: String,
        latitude: String,
        longitude: String,
        population: String
    ) {
        self.id = id
        self.name = name
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
        self.population = population
        self.createdAt = Date()
    }
}

extension CityEntity {
    convenience init(city: City) {
        self.init(
            name: city.name,
            country: city.country,
            latitude: city.latitude,
            longitude: city.longitude,
            population: city.population
        )
    }
}
