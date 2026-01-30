//
//  MockCityRepository.swift
//  WeatherDemoAppTests
//
//  Created by Dat Bui on 30/1/26.
//

import Foundation
@testable import WeatherDemoApp

final class MockCityRepository: CityRepository {

    var searchTextReceived: String?
    var result: Result<[City], Error> = .success([])

    func searchCities(searchText: String) async throws -> [City] {
        searchTextReceived = searchText
        return try result.get()
    }
}
