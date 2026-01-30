//
//  RemoteCityRepositoryTests.swift
//  WeatherDemoAppTests
//
//  Created by Dat Bui on 30/1/26.
//

import XCTest
@testable import WeatherDemoApp

@MainActor
final class RemoteCityRepositoryTests: XCTestCase {

    private var networkService: MockCityNetworkService!
    private var repository: RemoteCityRepository!

    override func setUp() {
        super.setUp()
        networkService = MockCityNetworkService()
        repository = RemoteCityRepository(networkService: networkService)
    }

    override func tearDown() {
        networkService = nil
        repository = nil
        super.tearDown()
    }

    // MARK: - Tests
    func test_searchCities_returnsMappedCities() async throws {
        // Arrange
        let response = SearchCityResponse(
            searchAPI: SearchAPI(
                cities: [
                    CityResponse(
                        areaName: [.init(value: "Hanoi")],
                        country: [.init(value: "Vietnam")],
                        weatherUrl: [.init(value: "url")],
                        latitude: "21.0285",
                        longitude: "105.8542",
                        population: "8000000"
                    )
                ]
            )
        )

        networkService.requestResult = .success(response)

        // Act
        let cities = try await repository.searchCities(searchText: "Hanoi")

        // Assert
        XCTAssertEqual(cities.count, 1)

        let city = cities.first
        XCTAssertEqual(city?.name, "Hanoi")
        XCTAssertEqual(city?.country, "Vietnam")
        XCTAssertEqual(city?.latitude, "21.0285")
        XCTAssertEqual(city?.longitude, "105.8542")
        XCTAssertEqual(city?.population, "8000000")
    }

    func test_searchCities_buildsCorrectEndpoint() async throws {
        // Arrange
        networkService.requestResult = .success(
            SearchCityResponse(
                searchAPI: SearchAPI(cities: [])
            )
        )

        // Act
        _ = try await repository.searchCities(searchText: "HCM")

        // Assert
        let endpoint = networkService.capturedEndpoint
        XCTAssertNotNil(endpoint)

        XCTAssertEqual(
            endpoint?.queryItems.first { $0.name == "query" }?.value,
            "HCM"
        )

        XCTAssertEqual(
            endpoint?.queryItems.first { $0.name == "num_of_results" }?.value,
            "10"
        )

        XCTAssertEqual(
            endpoint?.queryItems.first { $0.name == "format" }?.value,
            "json"
        )

        XCTAssertEqual(
            endpoint?.queryItems.first { $0.name == "key" }?.value,
            Constant.apiKey
        )
    }

    func test_searchCities_throwsError_whenNetworkThrows() async {
        // Arrange
        networkService.requestResult = .failure(URLError(.notConnectedToInternet))

        // Act / Assert
        do {
            _ = try await repository.searchCities(searchText: "Error")
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is URLError)
        }
    }

    func test_searchCities_mapsEmptyArraysToEmptyStrings() async throws {
        // Arrange
        let response = SearchCityResponse(
            searchAPI: SearchAPI(
                cities: [
                    CityResponse(
                        areaName: [],
                        country: [],
                        weatherUrl: [],
                        latitude: "0",
                        longitude: "0",
                        population: "0"
                    )
                ]
            )
        )

        networkService.requestResult = .success(response)

        // Act
        let cities = try await repository.searchCities(searchText: "Unknown")

        // Assert
        let city = cities.first
        XCTAssertEqual(city?.name, "")
        XCTAssertEqual(city?.country, "")
    }
}

final class MockCityNetworkService: NetworkService {

    var requestResult: Result<Decodable, Error>?
    private(set) var capturedEndpoint: Endpoint?

    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        capturedEndpoint = endpoint

        guard let requestResult else {
            fatalError("requestResult not set")
        }

        let value = try requestResult.get()

        guard let typedValue = value as? T else {
            fatalError("Type mismatch: expected \(T.self)")
        }

        return typedValue
    }

    func loadImage(urlString: String) async throws -> Data? {
        fatalError("Not needed for RemoteCityRepository tests")
    }
}
