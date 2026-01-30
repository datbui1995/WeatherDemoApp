//
//  SearchCityResponseTests.swift
//  WeatherDemoAppTests
//
//  Created by Dat Bui on 30/1/26.
//

import XCTest
@testable import WeatherDemoApp

@MainActor
final class SearchCityResponseTests: XCTestCase {

    func test_decodeSearchCityResponse_success() throws {
        // GIVEN
        let json = """
        {
          "search_api": {
            "result": [
              {
                "areaName": [{ "value": "London" }],
                "country": [{ "value": "United Kingdom" }],
                "weatherUrl": [{ "value": "https://example.com" }],
                "latitude": "51.51",
                "longitude": "-0.13",
                "population": "7556900"
              }
            ]
          }
        }
        """.data(using: .utf8)!

        // WHEN
        let response = try JSONDecoder().decode(SearchCityResponse.self, from: json)

        // THEN
        XCTAssertEqual(response.searchAPI.cities.count, 1)

        let city = response.searchAPI.cities.first
        XCTAssertEqual(city?.areaName.first?.value, "London")
        XCTAssertEqual(city?.country.first?.value, "United Kingdom")
        XCTAssertEqual(city?.latitude, "51.51")
        XCTAssertEqual(city?.longitude, "-0.13")
        XCTAssertEqual(city?.population, "7556900")
    }

    func test_cityResponse_toDomain_mapping() {
        // GIVEN
        let cityResponse = CityResponse(
            areaName: [StringValueResponse(value: "Tokyo")],
            country: [StringValueResponse(value: "Japan")],
            weatherUrl: [],
            latitude: "35.68",
            longitude: "139.69",
            population: "13929286"
        )

        // WHEN
        let city = cityResponse.toDomain()

        // THEN
        XCTAssertEqual(city.name, "Tokyo")
        XCTAssertEqual(city.country, "Japan")
        XCTAssertEqual(city.latitude, "35.68")
        XCTAssertEqual(city.longitude, "139.69")
        XCTAssertEqual(city.population, "13929286")
    }

    func test_cityResponse_toDomain_emptyValues() {
        // GIVEN
        let cityResponse = CityResponse(
            areaName: [],
            country: [],
            weatherUrl: [],
            latitude: "",
            longitude: "",
            population: ""
        )

        // WHEN
        let city = cityResponse.toDomain()

        // THEN
        XCTAssertEqual(city.name, "")
        XCTAssertEqual(city.country, "")
    }

    func test_equatable_conformance() {
        // GIVEN
        let city1 = StringValueResponse(value: "Hanoi")
        let city2 = StringValueResponse(value: "Hanoi")

        // THEN
        XCTAssertEqual(city1, city2)
    }
}
