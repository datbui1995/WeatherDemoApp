//
//  AppCoordinatorTests.swift
//  WeatherDemoAppTests
//
//  Created by Dat Bui on 30/1/26.
//

import XCTest
import SwiftUI
import Combine
@testable import WeatherDemoApp

@MainActor
final class AppCoordinatorTests: XCTestCase {

    private var navigation: SpyNavigationController!
    private var coordinator: AppCoordinator!
    private var homeViewModel: SpyHomeViewModel!
    private var diContainer: FakeAppDIContainer!

    override func setUp() {
        super.setUp()
        navigation = SpyNavigationController()
        homeViewModel = SpyHomeViewModel()
        diContainer = FakeAppDIContainer(homeViewModel: homeViewModel)
        coordinator = AppCoordinator(
            navigation: navigation,
            appDIContainer: diContainer
        )
    }

    override func tearDown() {
        coordinator = nil
        navigation = nil
        homeViewModel = nil
        diContainer = nil
        super.tearDown()
    }
    
    func test_start_pushesHomeViewController() {
        // When
        coordinator.start()

        // Then
        XCTAssertEqual(navigation.pushedViewControllers.count, 1)
        XCTAssertTrue(
            navigation.pushedViewControllers.first is HomeViewController
        )
    }
    
    func test_detailRoute_pushesDetailViewController() {
        coordinator.start()

        let city = Mock.mockCity
        homeViewModel.navigation.send(.detail(city))

        XCTAssertEqual(navigation.pushedViewControllers.count, 2)
    }
}
