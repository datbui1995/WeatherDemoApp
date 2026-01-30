//
//  LocalHistoryRepositoryTests.swift
//  WeatherDemoAppTests
//
//  Created by Dat Bui on 30/1/26.
//

import XCTest
@testable import WeatherDemoApp

final class LocalHistoryRepositoryTests: XCTestCase {

    private var sut: LocalHistoryRepository!
    private var service: SpySwiftDataService!

    override func setUp() {
        super.setUp()
        service = SpySwiftDataService()
        sut = LocalHistoryRepository(service: service)
    }

    override func tearDown() {
        sut = nil
        service = nil
        super.tearDown()
    }
    
    func test_addToHistory_savesCityViaService() {
        // Given
        let city = Mock.mockCity

        // When
        sut.addToHistory(city: city)

        // Then
        XCTAssertEqual(service.savedCities, [city])
    }
    
    func test_getHistory_returnsMappedCities_whenFetchSucceeds() {
        // Given
        let entity = CityEntity(
            name: "Hanoi",
            country: "VN",
            latitude: "21.036139",
            longitude: "105.810481",
            population: "9000000"
        )

        service.fetchResult = .success([entity])

        // When
        let result = sut.getHistory()

        // Then
        XCTAssertEqual(result.count, 1)

        let city = result.first
        XCTAssertEqual(city?.name, "Hanoi")
        XCTAssertEqual(city?.country, "VN")
        XCTAssertEqual(city?.latitude, "21.036139")
        XCTAssertEqual(city?.longitude, "105.810481")
        XCTAssertEqual(city?.population, "9000000")
    }

    func test_getHistory_returnsEmptyArray_whenFetchThrows() {
        // Given
        service.fetchResult = .failure(NSError(domain: "test", code: 0))

        // When
        let result = sut.getHistory()

        // Then
        XCTAssertTrue(result.isEmpty)
    }
}
