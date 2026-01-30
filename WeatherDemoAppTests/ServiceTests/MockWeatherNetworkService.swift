//
//  MockWeatherNetworkService.swift
//  WeatherDemoAppTests
//
//  Created by Dat Bui on 30/1/26.
//

import Foundation
@testable import WeatherDemoApp

final class MockWeatherNetworkService: NetworkService {

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
        fatalError("Not needed for RemoteDetailCityRepository tests")
    }
}
