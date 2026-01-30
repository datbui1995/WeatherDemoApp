//
//  ImplSwiftDataServiceTests.swift
//  WeatherDemoAppTests
//
//  Created by Dat Bui on 30/1/26.
//

//
//  ImplSwiftDataServiceTests.swift
//

import XCTest
import SwiftData
@testable import WeatherDemoApp

@MainActor
final class ImplSwiftDataServiceTests: XCTestCase {

    private var context: ModelContext!
    private var service: ImplSwiftDataService!

    // MARK: - Setup

    override func setUpWithError() throws {
        try super.setUpWithError()
        context = try makeInMemoryContext()
        service = ImplSwiftDataService(context: context)
    }

    override func tearDown() {
        context = nil
        service = nil
        super.tearDown()
    }

    // MARK: - Helpers

    private func makeInMemoryContext() throws -> ModelContext {
        let schema = Schema([CityEntity.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)

        let container = try ModelContainer(
            for: schema,
            configurations: [config]
        )

        return ModelContext(container)
    }

    // MARK: - Tests

    func test_save_insertsCity() {
        // Given
        let city = Mock.mockCity

        // When
        service.save(city: city)

        // Then
        let result = service.fetchCities()
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.name, "Hanoi")
        XCTAssertEqual(result.first?.country, "VN")
    }

    func test_save_existingCity_updatesCreatedAt_notDuplicate() {
        // Given
        let city = Mock.mockCity
        service.save(city: city)

        let firstCreatedAt = service.fetchCities().first!.createdAt
        usleep(10_000) // ensure timestamp difference

        // When
        service.save(city: city)

        // Then
        let result = service.fetchCities()
        XCTAssertEqual(result.count, 1)
        XCTAssertTrue(result.first!.createdAt > firstCreatedAt)
    }

    func test_fetchCities_sortedByCreatedAtDescending() {
        // Given
        let city1 = City(
            name: "Hanoi",
            country: "VN",
            latitude: "1",
            longitude: "1",
            population: "1"
        )

        let city2 = City(
            name: "Saigon",
            country: "VN",
            latitude: "2",
            longitude: "2",
            population: "2"
        )

        service.save(city: city1)
        usleep(10_000)
        service.save(city: city2)

        // When
        let result = service.fetchCities()

        // Then
        XCTAssertEqual(result.first?.name, "Saigon")
        XCTAssertEqual(result.last?.name, "Hanoi")
    }

    func test_fetchCities_respectsFetchLimit() {
        // Given
        let limit = Constant.limitedHistory

        for i in 0..<(limit + 3) {
            let city = City(
                name: "City\(i)",
                country: "VN",
                latitude: "\(i)",
                longitude: "\(i)",
                population: "\(i)"
            )
            service.save(city: city)
        }

        // When
        let result = service.fetchCities()

        // Then
        XCTAssertEqual(result.count, limit)
    }

//    func test_init_withNilContext_doesNotCrash_andIsNoOp() {
//        // Given
//        let sut = ImplSwiftDataService(context: nil)
//
//        // When
//        sut.save(city: Mock.mockCity)
//        let result = sut.fetchCities()
//
//        // Then
//        XCTAssertTrue(result.isEmpty)
//    }
}
