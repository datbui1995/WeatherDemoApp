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

@MainActor
final class SpyHomeViewModel: HomeViewModel {

    // MARK: - Outputs
    let citiesSubject = PassthroughSubject<[City], Never>()
    var citiesPublisher: AnyPublisher<[City], Never> {
        citiesSubject.eraseToAnyPublisher()
    }

    let navigation = PassthroughSubject<Route, Never>()

    // MARK: - Inputs tracking
    private(set) var receivedSearchTexts: [String] = []
    private(set) var selectedCities: [City] = []

    func updateSearchText(_ text: String) {
        receivedSearchTexts.append(text)
    }

    func didSelect(city: City) {
        selectedCities.append(city)
    }
}
