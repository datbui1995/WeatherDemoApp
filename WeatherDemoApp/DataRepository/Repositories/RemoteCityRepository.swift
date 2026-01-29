//
//  RemoteCityRepository.swift
//  WeatherDemoApp
//
//  Created by Dat Bui on 29/1/26.
//

import Foundation

final class RemoteCityRepository: CityRepository {
    
    private let networkService: NetworkService
    
    init (networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func searchCities(searchText: String) async throws -> [City] {
        let endpoint = Endpoint(
            url: Constant.searchURL,
            queryItems: [
                .init(name: "key", value: Constant.apiKey),
                .init(name: "query", value: searchText),
                .init(name: "format", value: "json"),
                .init(name: "num_of_results", value: "10")
            ]
        )
        
        let response: SearchCityResponse = try await networkService.request(endpoint)
        return response.searchAPI.cities.map { $0.toDomain() }
    }
}
