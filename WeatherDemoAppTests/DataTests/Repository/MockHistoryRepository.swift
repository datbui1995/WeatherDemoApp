//
//  MockHistoryRepository.swift
//  WeatherDemoAppTests
//
//  Created by Dat Bui on 30/1/26.
//

import Foundation
@testable import WeatherDemoApp

final class MockHistoryRepository: HistoryRepository {

    private(set) var addedCity: City?
    private var storedCities: [City] = []

    func addToHistory(city: City) {
        addedCity = city
        storedCities.append(city)
    }

    func getHistory() -> [City] {
        storedCities
    }
}
