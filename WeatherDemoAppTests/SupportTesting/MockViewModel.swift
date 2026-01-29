//
//  MockViewModel.swift
//  WeatherDemoAppTests
//
//  Created by Dat Bui on 30/1/26.
//

import Foundation
import Combine
import UIKit
@testable import WeatherDemoApp

protocol HomeViewModel {
    var navigation: PassthroughSubject<Route, Never> { get }
}

@MainActor
final class MockHomeViewModel: HomeViewModel {
    let navigation = PassthroughSubject<Route, Never>()
}

final class MockDetailCityViewModel: DetailCityViewModel {
    var currentWeather: WeatherDemoApp.CurrentWeather = .empty
    var uiImage: UIImage? = nil
    
    let city: City
    init(city: City) {
        self.city = city
    }
    
    func loadData() {
        
    }
}

@MainActor
final class MockAppDIContainer: AppDIContainer {
    let homeViewModel = MockHomeViewModel()
    private(set) var receivedCity: City?
    
    func makeHomeViewModel() -> HomeViewModel {
        homeViewModel
    }
    
    func makeDetailViewModel(city: City) -> any DetailCityViewModel {
        receivedCity = city
        return MockDetailCityViewModel(city: city)
    }
}
