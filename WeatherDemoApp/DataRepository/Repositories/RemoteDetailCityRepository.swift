//
//  RemoteDetailCityRepository.swift
//  WeatherDemoApp
//
//  Created by Dat Bui on 29/1/26.
//
import Foundation
final class RemoteDetailCityRepository: DetailWeatherCityRepository {
    private let networkService: NetworkService
    
    init (networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchCurrentWeather(latitude: String, longitude: String) async throws -> CurrentWeather {
        let query = "\(latitude),\(longitude)"
        let endpoint = Endpoint(
            url: Constant.weatherURL,
            queryItems: [
                .init(name: "key", value: Constant.apiKey),
                .init(name: "query", value: query),
                .init(name: "format", value: "json"),
                .init(name: "num_of_days", value: "1")
            ]
        )
        
        let response: WeatherResponse = try await networkService.request(endpoint)
        return response.toCurrentWeather()
    }
}
