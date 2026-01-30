//
//  WeatherResponseTests.swift
//  WeatherDemoAppTests
//
//  Created by Dat Bui on 30/1/26.
//

import XCTest
@testable import WeatherDemoApp

final class WeatherResponseTests: XCTestCase {

    func test_toCurrentWeather_mapsCorrectly_whenCurrentConditionExists() {
        // Arrange
        let response = WeatherResponse(
            data: WeatherData(
                currentCondition: [
                    CurrentCondition(
                        imageURL: [StringValueResponse(value: "https://icon.png")],
                        description: [StringValueResponse(value: "Sunny")],
                        temperature: "30",
                        humidity: "70"
                    )
                ]
            )
        )

        // Act
        let result = response.toCurrentWeather()

        // Assert
        let expected = CurrentWeather(
            imageURL: "https://icon.png",
            description: "Sunny",
            temperature: "30",
            humidity: "70"
        )

        XCTAssertEqual(result, expected)
    }

    func test_toCurrentWeather_returnsEmpty_whenCurrentConditionIsEmpty() {
        // Arrange
        let response = WeatherResponse(
            data: WeatherData(currentCondition: [])
        )

        // Act
        let result = response.toCurrentWeather()

        // Assert
        XCTAssertEqual(result, .empty)
    }

    func test_toCurrentWeather_handlesEmptyImageAndDescriptionArrays() {
        // Arrange
        let response = WeatherResponse(
            data: WeatherData(
                currentCondition: [
                    CurrentCondition(
                        imageURL: [],
                        description: [],
                        temperature: "25",
                        humidity: "60"
                    )
                ]
            )
        )

        // Act
        let result = response.toCurrentWeather()

        // Assert
        XCTAssertEqual(result.imageURL, "")
        XCTAssertEqual(result.description, "")
        XCTAssertEqual(result.temperature, "25")
        XCTAssertEqual(result.humidity, "60")
    }
}
