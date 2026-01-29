//
//  CityRepository.swift
//  WeatherDemoApp
//
//  Created by Dat Bui on 29/1/26.
//

import Foundation

protocol CityRepository {
    func searchCities(searchText: String) async throws -> [City]
}
