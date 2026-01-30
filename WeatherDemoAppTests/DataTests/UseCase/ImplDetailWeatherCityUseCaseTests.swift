//
//  ImplDetailWeatherCityUseCaseTests.swift
//  WeatherDemoAppTests
//
//  Created by Dat Bui on 30/1/26.
//

import XCTest
@testable import WeatherDemoApp

final class ImplDetailWeatherCityUseCaseTests: XCTestCase {

    private var repository: MockDetailWeatherCityRepository!
    private var cacheRepository: MockWeatherCacheRepository!
    private var useCase: ImplDetailWeatherCityUseCase!

    override func setUp() {
        super.setUp()
        repository = MockDetailWeatherCityRepository()
        cacheRepository = MockWeatherCacheRepository()
        useCase = ImplDetailWeatherCityUseCase(
            repository: repository,
            weatherCacheRepository: cacheRepository
        )
    }

    override func tearDown() {
        repository = nil
        cacheRepository = nil
        useCase = nil
        super.tearDown()
    }

    // MARK: - Cache hit

    func test_fetchCurrentWeather_returnsCachedValue_whenCacheExists() async {
        // Arrange
        let cached = CurrentWeather(
            imageURL: "icon",
            description: "Sunny",
            temperature: "30",
            humidity: "70"
        )
        cacheRepository.cachedWeather = cached

        // Act
        let result = await useCase.fetchCurrentWeather(
            latitude: "10",
            longitude: "106"
        )

        // Assert
        XCTAssertEqual(result, cached)
        XCTAssertEqual(cacheRepository.getCalledWithKey, "cached10,106")
        XCTAssertNil(repository.fetchCalledWith)
    }

    // MARK: - Cache miss + API success

    func test_fetchCurrentWeather_fetchesFromRepository_andCachesResult_whenCacheMiss() async {
        // Arrange
        let weather = CurrentWeather(
            imageURL: "icon",
            description: "Cloudy",
            temperature: "28",
            humidity: "65"
        )

        cacheRepository.cachedWeather = nil
        repository.result = .success(weather)

        // Act
        let result = await useCase.fetchCurrentWeather(
            latitude: "21",
            longitude: "105"
        )

        // Assert
        XCTAssertEqual(result, weather)
        XCTAssertEqual(repository.fetchCalledWith?.lat, "21")
        XCTAssertEqual(repository.fetchCalledWith?.lon, "105")
        XCTAssertEqual(cacheRepository.setCalledWith?.weather, weather)
        XCTAssertEqual(cacheRepository.setCalledWith?.key, "cached21,105")
    }

    // MARK: - Cache miss + API failure
    func test_fetchCurrentWeather_returnsEmpty_whenRepositoryThrows() async {
        // Arrange
        cacheRepository.cachedWeather = nil
        repository.result = .failure(URLError(.badServerResponse))

        // Act
        let result = await useCase.fetchCurrentWeather(
            latitude: "21",
            longitude: "105"
        )

        // Assert
        XCTAssertEqual(result, .empty)
        XCTAssertEqual(repository.fetchCalledWith?.lat, "21")
        XCTAssertEqual(repository.fetchCalledWith?.lon, "105")
        XCTAssertNil(cacheRepository.setCalledWith)
    }
}

