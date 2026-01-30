//
//  MockDetailWeatherCityRepository.swift
//  WeatherDemoAppTests
//
//  Created by Dat Bui on 30/1/26.
//

import Foundation
@testable import WeatherDemoApp

final class MockDetailWeatherCityRepository: DetailWeatherCityRepository {

    var result: Result<CurrentWeather, Error>?
    private(set) var fetchCalledWith: (lat: String, lon: String)?

    func fetchCurrentWeather(latitude: String, longitude: String) async throws -> CurrentWeather {
        fetchCalledWith = (latitude, longitude)

        if let result {
            return try result.get()
        }

        fatalError("Result not set")
    }
}

final class MockWeatherCacheRepository: WeatherCacheRepository {

    var cachedWeather: CurrentWeather?
    private(set) var getCalledWithKey: String?
    private(set) var setCalledWith: (weather: CurrentWeather, key: String)?

    func get(key: String) -> CurrentWeather? {
        getCalledWithKey = key
        return cachedWeather
    }

    func set(_ value: CurrentWeather, for key: String) {
        setCalledWith = (value, key)
    }
}
