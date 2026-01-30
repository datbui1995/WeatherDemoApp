//
//  DIContainerTests.swift
//  WeatherDemoAppTests
//
//  Created by Dat Bui on 30/1/26.
//

import XCTest
import SwiftData
@testable import WeatherDemoApp

// MARK: - Tests

final class AppDIContainerTests: XCTestCase {
    private var container: AppDIContainer!
    var weatherUseCase: DetailWeatherCityUseCase!
    var imageUseCase: ImageUseCase!
    var detailViewModel: ImplDetailCityViewModel!
    // MARK: - Setup
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        container = AppDIContainer(
            networkService: MockDINetworkService(),
            localService: MockSwiftDataService()
        )
    }
    
    override func tearDown() {
        container = nil
        super.tearDown()
    }
    
    private func makeInMemoryContext() throws -> ModelContext {
        let schema = Schema([CityEntity.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)

        let container = try ModelContainer(
            for: schema,
            configurations: [config]
        )

        return ModelContext(container)
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

    @MainActor
    func test_makeWeatherUseCase_returnsDetailWeatherCityUseCase() {
        // When
        weatherUseCase = container.makeWeatherUseCase()

        // Then
        XCTAssertNotNil(weatherUseCase)
    }
    
    func test_makeImageUseCase_returnsImageUseCase() {
        // When
        imageUseCase = container.makeImageUseCase()

        // Then
        XCTAssertNotNil(imageUseCase)
    }
    func test_makeDetailViewModel_returnsImplDetailCityViewModel() {
        let city = City(name: "Hanoi", country: "Vietnam", latitude: "12", longitude: "10", population: "9000")
        detailViewModel = container.makeDetailViewModel(city: city)
        XCTAssertNotNil(detailViewModel)
    }
}

final class MockSwiftDataService: SwiftDataService {
    func save(city: WeatherDemoApp.City) {
        
    }
    func fetchCities() throws -> [WeatherDemoApp.CityEntity] {
        []
    }
}

final class MockDINetworkService: NetworkService {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        throw NSError(domain: "Mock", code: -1)
    }

    func loadImage(urlString: String) async throws -> Data? {
        return nil
    }
}
