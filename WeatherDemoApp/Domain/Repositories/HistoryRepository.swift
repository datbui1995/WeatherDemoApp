//
//  HistoryRepository.swift
//  WeatherDemoApp
//
//  Created by Dat Bui on 29/1/26.
//

import Foundation

protocol HistoryRepository {
    func addToHistory(city: City)
    func getHistory() -> [City]
}
