//
//  SpyUseCase.swift
//  WeatherDemoAppTests
//
//  Created by Dat Bui on 30/1/26.
//

import Foundation
import UIKit
@testable import WeatherDemoApp

final class SpyDetailWeatherCityUseCase: DetailWeatherCityUseCase {
    
    private(set) var receivedLatitude: String?
    private(set) var receivedLongitude: String?
    
    var stubbedWeather: CurrentWeather = .empty
    
    func fetchCurrentWeather(latitude: String, longitude: String) async -> CurrentWeather {
        receivedLatitude = latitude
        receivedLongitude = longitude
        return stubbedWeather
    }
}

final class SpyImageUseCase: ImageUseCase {
    
    private(set) var receivedURL: String?
    var stubbedImage: UIImage?
    
    func loadImage(urlString: String) async throws -> UIImage {
        receivedURL = urlString
        return stubbedImage ?? UIImage()
    }
    
    func loadImage(urlString: String) async throws -> UIImage? {
        nil
    }
}

final class SpyHistoryUseCase: HistoryUseCase {
    
    private(set) var savedCity: City?
    var histories: [City] = []
    private(set) var didCallGetHistory = false
    
    func saveCityHistory(city: City) {
        savedCity = city
    }
    func getCityHistories() -> [WeatherDemoApp.City] {
        didCallGetHistory = true
        return histories
    }
}

final class SpySearchUseCase: SearchUseCase {
    
    enum SpyError: Error {
        case failure
    }
    
    private(set) var receivedQuery: String?
    var result: Result<[City], Error> = .success([])
    
    func search(cityName: String) async throws -> [City] {
        receivedQuery = cityName
        return try result.get()
    }
}
