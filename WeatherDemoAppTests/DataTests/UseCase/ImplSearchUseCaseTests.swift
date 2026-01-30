//
//  ImplSearchUseCaseTests.swift
//  WeatherDemoAppTests
//
//  Created by Dat Bui on 30/1/26.
//

import XCTest
@testable import WeatherDemoApp

final class ImplSearchUseCaseTests: XCTestCase {

    func test_search_returnsCities_whenRepositorySucceeds() async throws {
        // Arrange
        let mockRepo = MockCityRepository()

        let expectedCities = [
            City(
                name: "Hanoi",
                country: "VN",
                latitude: "21.0285",
                longitude: "105.8542",
                population: "8000000"
            ),
            City(
                name: "Ho Chi Minh City",
                country: "VN",
                latitude: "10.8231",
                longitude: "106.6297",
                population: "9000000"
            )
        ]

        mockRepo.result = .success(expectedCities)

        let useCase = ImplSearchUseCase(repoCity: mockRepo)

        // Act
        let result = try await useCase.search(cityName: "Ha")

        // Assert
        XCTAssertEqual(result, expectedCities)
        XCTAssertEqual(mockRepo.searchTextReceived, "Ha")
    }
    
    func test_search_throwsError_whenRepositoryFails() async {
        // Arrange
        let mockRepo = MockCityRepository()
        let expectedError = URLError(.cannotConnectToHost)
        mockRepo.result = .failure(expectedError)

        let useCase = ImplSearchUseCase(repoCity: mockRepo)

        // Act & Assert
        do {
            _ = try await useCase.search(cityName: "Ha")
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? URLError, expectedError)
        }
    }
}
