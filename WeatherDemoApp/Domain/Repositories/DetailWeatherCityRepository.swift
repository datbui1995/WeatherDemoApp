//
//  DetailWeatherCityRepository.swift
//  WeatherDemoApp
//
//  Created by Dat Bui on 29/1/26.
//

protocol DetailWeatherCityRepository {
    func fetchCurrentWeather(latitude: String, longitude: String) async throws -> CurrentWeather
}
