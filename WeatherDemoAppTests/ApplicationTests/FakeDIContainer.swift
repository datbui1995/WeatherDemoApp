//
//  FakeDIContainer.swift
//  WeatherDemoApp
//
//  Created by Dat Bui on 30/1/26.
//

import UIKit
import Combine
@testable import WeatherDemoApp

final class FakeAppDIContainer: AppDIContainerMakingViewModelType {

    let homeViewModel: SpyHomeViewModel

    init(homeViewModel: SpyHomeViewModel) {
        self.homeViewModel = homeViewModel
    }

    func makeHomeViewModel() -> any HomeViewModel {
        homeViewModel
    }

    func makeDetailViewModel(city: City) -> ImplDetailCityViewModel {
        // We do NOT care about internals — just need a valid instance
        ImplDetailCityViewModel(
            city: city,
            weatherUseCase: DummyWeatherUseCase(),
            imageUseCase: DummyImageUseCase(),
            historyUseCase: DummyHistoryUseCase()
        )
    }
}

final class DummyWeatherUseCase: DetailWeatherCityUseCase {
    func fetchCurrentWeather(latitude: String, longitude: String) async -> CurrentWeather {
        CurrentWeather.empty
    }
    
}

final class DummyImageUseCase: ImageUseCase {
    func loadImage(urlString: String) async throws -> UIImage? {
        nil
    }
    
}

final class DummyHistoryUseCase: HistoryUseCase {
    func saveCityHistory(city: City) {
        
    }
    func getCityHistories() -> [City] {
        []
    }
}
