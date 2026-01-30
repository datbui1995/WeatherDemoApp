//
//  RemoteDetailCityRepositoryTests.swift
//  WeatherDemoAppTests
//
//  Created by Dat Bui on 30/1/26.
//

import XCTest
@testable import WeatherDemoApp

@MainActor
final class RemoteDetailCityRepositoryTests: XCTestCase {

    private var networkService: MockWeatherNetworkService!
    private var repository: RemoteDetailCityRepository!

    override func setUp() {
        super.setUp()
        networkService = MockWeatherNetworkService()
        repository = RemoteDetailCityRepository(networkService: networkService)
    }

    override func tearDown() {
        networkService = nil
        repository = nil
        super.tearDown()
    }

    func test_fetchCurrentWeather_returnsMappedCurrentWeather() async throws {
        // Arrange
        let response = WeatherResponse(
            data: WeatherData(
                currentCondition: [
                    CurrentCondition(
                        imageURL: [.init(value: "icon")],
                        description: [.init(value: "Sunny")],
                        temperature: "30",
                        humidity: "70"
                    )
                ]
            )
        )

        networkService.requestResult = .success(response)

        // Act
        let weather = try await repository.fetchCurrentWeather(
            latitude: "10.0",
            longitude: "106.0"
        )

        // Assert
        XCTAssertEqual(weather.description, "Sunny")
        XCTAssertEqual(weather.temperature, "30")
        XCTAssertEqual(weather.humidity, "70")
        XCTAssertEqual(weather.imageURL, "icon")
    }

    func test_fetchCurrentWeather_buildsCorrectEndpoint() async throws {
        // Arrange
        networkService.requestResult = .success(
            WeatherResponse(
                data: WeatherData(currentCondition: [])
            )
        )

        // Act
        _ = try await repository.fetchCurrentWeather(
            latitude: "10.1",
            longitude: "106.2"
        )

        // Assert
        let endpoint = networkService.capturedEndpoint
        XCTAssertNotNil(endpoint)

        XCTAssertEqual(endpoint?.queryItems.first { $0.name == "query" }?.value,
                       "10.1,106.2")
        XCTAssertEqual(endpoint?.queryItems.first { $0.name == "num_of_days" }?.value,
                       "1")
        XCTAssertEqual(endpoint?.queryItems.first { $0.name == "format" }?.value,
                       "json")
    }

    func test_fetchCurrentWeather_throwsError_whenNetworkThrows() async {
        // Arrange
        networkService.requestResult = .failure(URLError(.notConnectedToInternet))

        // Act / Assert
        do {
            _ = try await repository.fetchCurrentWeather(
                latitude: "10",
                longitude: "106"
            )
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is URLError)
        }
    }
}
