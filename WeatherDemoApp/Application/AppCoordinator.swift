//
//  AppCoordinator.swift
//  WeatherDemoApp
//
//  Created by Dat Bui on 28/1/26.
//

import Foundation
import UIKit
import Combine
import SwiftUI

enum Route {
    case detail(City)
}

class AppCoordinator {
    
    private var navigation: UINavigationController
    private let appDIContainer: AppDIContainerMakingViewModelAction
    private var cancellables = Set<AnyCancellable>()
    
    init(navigation: UINavigationController,
         appDIContainer: AppDIContainerMakingViewModelAction) {
        self.navigation = navigation
        self.appDIContainer = appDIContainer
    }
    
    private func handle(route: Route) {
        switch route {
        case .detail(let city):
            showDetail(for: city)
        }
    }
    
    func start() {
        let vc = makeHomeViewController()
        navigation.pushViewController(vc, animated: true)
    }
    
    func showDetail(for city: City) {
        let vc = makeDetailCityViewController(city: city)
        navigation.pushViewController(vc, animated: true)
    }
}

extension AppCoordinator {
    private func makeHomeViewController() -> UIViewController {
        let viewModel = appDIContainer.makeHomeViewModel()
        viewModel.navigation.sink { [weak self] route in
            self?.handle(route: route)
        }.store(in: &cancellables)
        let vc = HomeViewController(viewModel: viewModel)
        return vc
    }
    
    private func makeDetailCityViewController(city: City) -> UIViewController {
        let viewModel = appDIContainer.makeDetailViewModel(city: city)
        let vc = UIHostingController(rootView: DetailCityView(viewModel: viewModel))
        return vc
    }
}
