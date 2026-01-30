//
//  DetailWeatherCityUseCase.swift
//  WeatherDemoApp
//
//  Created by Dat Bui on 29/1/26.
//
import Foundation

protocol DetailWeatherCityUseCase {
    func fetchCurrentWeather(latitude: String, longitude: String) async -> CurrentWeather
}

final class ImplDetailWeatherCityUseCase: DetailWeatherCityUseCase {
    let repository: DetailWeatherCityRepository
    let weatherCacheRepository: WeatherCacheRepository
    init(repository: DetailWeatherCityRepository, weatherCacheRepository: WeatherCacheRepository) {
        self.repository = repository
        self.weatherCacheRepository = weatherCacheRepository
    }
    
    func fetchCurrentWeather(latitude: String, longitude: String) async -> CurrentWeather {
        let cacheKey = "cached" + latitude + "," + longitude
        
        // retrieve from cache first
        if let cachedWeather = weatherCacheRepository.get(key: cacheKey) {
            return cachedWeather
        }
        
        // fetch from API
        do {
            let currentWeather = try await repository.fetchCurrentWeather(latitude: latitude,
                                                                          longitude: longitude)
            
            // save to cache
            weatherCacheRepository.set(currentWeather, for: cacheKey)
            return currentWeather
        } catch {
            print("fetchCurrentWeather with error: \(error.localizedDescription)")
            return CurrentWeather.empty
        }
    }
}
