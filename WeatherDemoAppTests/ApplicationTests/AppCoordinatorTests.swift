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

    private var navigation: MockNavigationController!
    private var diContainer: MockAppDIContainer!
    private var coordinator: AppCoordinator!

    override func setUp() {
        super.setUp()
        navigation = MockNavigationController()
        diContainer = MockAppDIContainer(networkService: ImplNetworkService(), localService: ImplSwiftDataService())
        coordinator = AppCoordinator(
            navigation: navigation,
            appDIContainer: diContainer
        )
    }

    // MARK: - start()

    func test_start_pushesHomeViewController() {
        // When
        coordinator.start()

        // Then
        XCTAssertEqual(navigation.pushedViewControllers.count, 1)
        XCTAssertTrue(
            navigation.pushedViewControllers.first is HomeViewController
        )
    }

}
