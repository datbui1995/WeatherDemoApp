//
//  LocalCacheWeatherRepositoryTests.swift
//  WeatherDemoAppTests
//
//  Created by Dat Bui on 30/1/26.
//

import XCTest
@testable import WeatherDemoApp

final class LocalCacheWeatherRepositoryTests: XCTestCase {

    private var repository: LocalCacheWeatherRepository!

    override func setUp() {
        super.setUp()
        repository = LocalCacheWeatherRepository()
    }

    override func tearDown() {
        repository = nil
        super.tearDown()
    }

    // MARK: - Tests

    @MainActor
    func test_get_returnsNil_whenCacheIsEmpty() {
        let result = repository.get(key: "missing-key")
        XCTAssertNil(result)
    }

    @MainActor
    func test_set_thenGet_returnsCachedValue_beforeExpiry() {
        let weather = makeWeather()
        let key = "weather-key"

        repository.set(weather, for: key)
        let cached = repository.get(key: key)

        XCTAssertNotNil(cached)
        XCTAssertEqual(cached?.temperature, weather.temperature)
        XCTAssertEqual(cached?.humidity, weather.humidity)
    }

    @MainActor
    func test_get_returnsNil_whenCacheItemIsExpired() {
        let key = "expired-key"
        let weather = makeWeather()

        // Insert expired CacheItem via reflection
        let cache = extractCache(from: repository)
        let expiredItem = CacheItem(
            value: weather,
            expiry: Date().addingTimeInterval(-1) // already expired
        )
        cache.setObject(expiredItem, forKey: key as NSString)

        let result = repository.get(key: key)

        XCTAssertNil(result)
    }
}

// MARK: - Test helpers

@MainActor
private func makeWeather() -> CurrentWeather {
    CurrentWeather(
        imageURL: "icon",
        description: "Sunny",
        temperature: "30",
        humidity: "70"
    )
}

/// Access private NSCache via reflection (test-only)
private func extractCache(from repository: LocalCacheWeatherRepository)
-> NSCache<NSString, CacheItem> {

    let mirror = Mirror(reflecting: repository)

    for child in mirror.children {
        if let cache = child.value as? NSCache<NSString, CacheItem> {
            return cache
        }
    }
    fatalError("NSCache not found via reflection")
}
