//
//  HistoryUseCase.swift
//  WeatherDemoApp
//
//  Created by Dat Bui on 29/1/26.
//

import Foundation

protocol HistoryUseCase {
    func saveCityHistory(city: City)
    func getCityHistories() -> [City]
}

final class ImplHistoryUseCase: HistoryUseCase {
    
    private let repository: HistoryRepository
    init(repository: HistoryRepository) {
        self.repository = repository
    }
    
    func saveCityHistory(city: City) {
        repository.addToHistory(city: city)
    }
    
    func getCityHistories() -> [City] {
        repository.getHistory()
    }
    
}
