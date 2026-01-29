//
//  SearchUseCase.swift
//  WeatherDemoApp
//
//  Created by Dat Bui on 29/1/26.
//

import Foundation

protocol SearchUseCase {
    func search(cityName: String) async throws -> [City]
}

final class ImplSearchUseCase: SearchUseCase {
    
    private let repoCity: CityRepository
    
    init(repoCity: CityRepository) {
        self.repoCity = repoCity
    }
    
    func search(cityName: String) async throws -> [City] {
        try await repoCity.searchCities(searchText: cityName)
    }
    
}
