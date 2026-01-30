//
//  DIContainerTests.swift
//  WeatherDemoAppTests
//
//  Created by Dat Bui on 30/1/26.
//

import XCTest
@testable import WeatherDemoApp

// MARK: - Tests

final class AppDIContainerTests: XCTestCase {

    private var container: AppDIContainer!

    override func setUp() {
        super.setUp()
        container = AppDIContainer(
            networkService: MockNetworkService(),
            localService: MockSwiftDataService()
        )
    }

    override func tearDown() {
        container = nil
        super.tearDown()
    }

    // MARK: - Network Service

    func test_makeNetworkService_returnsSameInstance() {
        let service1 = container.makeNetworkService()
        let service2 = container.makeNetworkService()

        XCTAssertTrue(service1 === service2)
    }

    // MARK: - Cache Image Repository

    func test_cacheImageRepo_isLazilyCreated_andReused() {
        let repo1 = container.cacheImageRepo
        let repo2 = container.cacheImageRepo

        XCTAssertTrue(repo1 === repo2)
        XCTAssertTrue(repo1 is CacheImageRepository)
    }

}

final class MockSwiftDataService: SwiftDataService {
    func save(city: WeatherDemoApp.City) {
        
    }
    func fetchCities() throws -> [WeatherDemoApp.CityEntity] {
        []
    }
}
