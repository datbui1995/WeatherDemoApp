//
//  WeatherCacheRepository.swift
//  WeatherDemoApp
//
//  Created by Dat Bui on 30/1/26.
//

import Foundation

protocol WeatherCacheRepository {
    func get(key: String) -> CurrentWeather?
    func set(_ value: CurrentWeather, for key: String)
}
