//
//  SpySwiftDataService.swift
//  WeatherDemoAppTests
//
//  Created by Dat Bui on 30/1/26.
//

import Foundation
@testable import WeatherDemoApp

final class SpySwiftDataService: SwiftDataService {

    // MARK: - Tracking
    private(set) var savedCities: [City] = []

    // MARK: - Stubbing
    var fetchResult: Result<[CityEntity], Error> = .success([])

    func save(city: City) {
        savedCities.append(city)
    }

    func fetchCities() throws -> [CityEntity] {
        try fetchResult.get()
    }
}
