//
//  DetailCityViewModel.swift
//  WeatherDemoApp
//
//  Created by Dat Bui on 29/1/26.
//
import Combine
import UIKit

protocol DetailCityViewModel: AnyObject, ObservableObject {
    func loadData()
    var city: City { get }
    var currentWeather: CurrentWeather { get }
    var uiImage: UIImage? { get }
}

final class ImplDetailCityViewModel: DetailCityViewModel {
    
    var city: City
    @Published var currentWeather: CurrentWeather = .empty
    @Published var uiImage: UIImage?
    
    let weatherUseCase: DetailWeatherCityUseCase
    let imageUseCase: ImageUseCase
    let historyUseCase: HistoryUseCase
    
    init(city: City, weatherUseCase: DetailWeatherCityUseCase,
         imageUseCase: ImageUseCase,
         historyUseCase: HistoryUseCase) {
        self.city = city
        self.weatherUseCase = weatherUseCase
        self.imageUseCase = imageUseCase
        self.historyUseCase = historyUseCase
    }
    
    func loadData() {
        Task {
            // Store history City
            historyUseCase.saveCityHistory(city: city)
            
            
            // Load weather
            let currentWeather = await fetchWeather()
            await MainActor.run { [weak self] in
                self?.currentWeather = currentWeather
            }
            
            // Load icon and cache
            let uiImage = try? await imageUseCase.loadImage(urlString: currentWeather.imageURL)
            await MainActor.run { [weak self] in
                self?.uiImage = uiImage
            }
        }
    }
}

extension ImplDetailCityViewModel {
    func fetchWeather() async -> CurrentWeather {
        await weatherUseCase.fetchCurrentWeather(latitude: city.latitude, longitude: city.longitude)
    }
}
