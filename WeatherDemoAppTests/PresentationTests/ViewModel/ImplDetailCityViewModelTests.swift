//
//  ImplDetailCityViewModelTests.swift
//  WeatherDemoAppTests
//
//  Created by Dat Bui on 30/1/26.
//

import XCTest
@testable import WeatherDemoApp

final class ImplDetailCityViewModelTests: XCTestCase {

    private var weatherUseCase: SpyDetailWeatherCityUseCase!
    private var imageUseCase: SpyImageUseCase!
    private var historyUseCase: SpyHistoryUseCase!
    private var viewModel: ImplDetailCityViewModel!

    override func setUp() {
        super.setUp()

        weatherUseCase = SpyDetailWeatherCityUseCase()
        imageUseCase = SpyImageUseCase()
        historyUseCase = SpyHistoryUseCase()

        let city = Mock.mockCity

        viewModel = ImplDetailCityViewModel(
            city: city,
            weatherUseCase: weatherUseCase,
            imageUseCase: imageUseCase,
            historyUseCase: historyUseCase
        )
    }
    
    func test_loadData_savesCityToHistory() async {
        viewModel.loadData()

        // Allow Task to execute
        try? await Task.sleep(nanoseconds: 50_000_000)

        XCTAssertEqual(historyUseCase.savedCity?.name, "Hanoi")
    }

    func test_loadData_fetchesWeatherWithCorrectCoordinates() async {
        let weather = CurrentWeather(
            imageURL: "30",
            description: "Sunny",
            temperature: "icon_url", humidity: "70"
        )

        weatherUseCase.stubbedWeather = weather

        viewModel.loadData()
        try? await Task.sleep(nanoseconds: 50_000_000)

        XCTAssertEqual(weatherUseCase.receivedLatitude, Mock.mockCity.latitude)
        XCTAssertEqual(weatherUseCase.receivedLongitude, Mock.mockCity.longitude)
    }

}

