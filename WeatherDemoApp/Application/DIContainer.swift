//
//  DIContainer.swift
//  WeatherDemoApp
//
//  Created by Dat Bui on 28/1/26.
//

import Foundation
import UIKit

protocol AppDIContainerMakingViewModelType {
    func makeHomeViewModel() -> any HomeViewModel
    func makeDetailViewModel(city: City) -> ImplDetailCityViewModel
}

class AppDIContainer: AppDIContainerMakingViewModelType {
    
    private let networkService: NetworkService
    private let localService: SwiftDataService
    
    // Caching should be store in global state
    lazy var cacheImageRepo: ImageRepository = {
        CacheImageRepository(networkService: networkService)
    }()
    let cacheWeatherRepo = LocalCacheWeatherRepository()
    
    init(networkService: NetworkService, localService: SwiftDataService) {
        self.networkService = networkService
        self.localService = localService
    }
    
    public func makeNetworkService() -> NetworkService {
        return networkService
    }
}

extension AppDIContainer {
    func makeHomeViewModel() -> any HomeViewModel {
        let viewModel = ImplHomeViewModel(searchUseCase: makeSearchUseCase(),
                                          historyUseCase: makeHistoryUseCase())
        return viewModel
    }
    
    // Make this concrete type to conform SwiftUI style
    func makeDetailViewModel(city: City) -> ImplDetailCityViewModel {
        let viewModel = ImplDetailCityViewModel(city: city, weatherUseCase: makeWeatherUseCase(),
                                                imageUseCase: makeImageUseCase(),
                                                historyUseCase: makeHistoryUseCase())
        return viewModel
    }
}

extension AppDIContainer {
    private func makeSearchUseCase() -> any SearchUseCase {
        let repo = RemoteCityRepository(networkService: networkService)
        let useCase = ImplSearchUseCase(repoCity: repo)
        return useCase
    }
    
    private func makeWeatherUseCase() -> any DetailWeatherCityUseCase {
        let repo = RemoteDetailCityRepository(networkService: networkService)
        let useCase = ImplDetailWeatherCityUseCase(repository: repo, weatherCacheRepository: cacheWeatherRepo)
        return useCase
    }
    
    private func makeImageUseCase() -> any ImageUseCase {
        let imageUseCase = ImplImageUseCase(repository: cacheImageRepo)
        return imageUseCase
    }
    
    private func makeHistoryUseCase() -> any HistoryUseCase {
        let historyRepo = LocalHistoryRepository(service: localService)
        let historyUseCase = ImplHistoryUseCase(repository: historyRepo)
        return historyUseCase
    }
}
