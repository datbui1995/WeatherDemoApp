//
//  LocalHistoryRepository.swift
//  WeatherDemoApp
//
//  Created by Dat Bui on 29/1/26.
//

import Foundation

final class LocalHistoryRepository: HistoryRepository {
    
    private let service: SwiftDataService
    init(service: SwiftDataService) {
        self.service = service
    }
    
    func addToHistory(city: City) {
        service.save(city: city)
    }
    
    func getHistory() -> [City] {
        do {
            return try service.fetchCities().map { City(entity: $0) }
        } catch {
            return []
        }
    }
}
