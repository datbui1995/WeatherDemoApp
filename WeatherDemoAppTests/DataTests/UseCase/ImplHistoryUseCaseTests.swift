//
//  ImplHistoryUseCaseTests.swift
//  WeatherDemoAppTests
//
//  Created by Dat Bui on 30/1/26.
//

import XCTest
@testable import WeatherDemoApp

final class ImplHistoryUseCaseTests: XCTestCase {

    private var repository: MockHistoryRepository!
    private var useCase: ImplHistoryUseCase!

    override func setUp() {
        super.setUp()
        repository = MockHistoryRepository()
        useCase = ImplHistoryUseCase(repository: repository)
    }

    override func tearDown() {
        repository = nil
        useCase = nil
        super.tearDown()
    }

    func test_saveCityHistory_delegatesToRepository() {
        // Given
        let city = City(
            name: "Hanoi",
            country: "VN",
            latitude: "21.036139",
            longitude: "105.810481",
            population: "9000000"
        )

        // When
        useCase.saveCityHistory(city: city)

        // Then
        XCTAssertEqual(repository.addedCity?.name, "Hanoi")
        XCTAssertEqual(repository.addedCity?.country, "VN")
    }
}

