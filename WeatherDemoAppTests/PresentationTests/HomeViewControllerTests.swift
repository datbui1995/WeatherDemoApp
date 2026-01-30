//
//  HomeViewControllerTests.swift
//  WeatherDemoAppTests
//
//  Created by Dat Bui on 30/1/26.
//

import XCTest
import Combine
@testable import WeatherDemoApp

@MainActor
final class HomeViewControllerTests: XCTestCase {

    private var sut: HomeViewController!
    private var viewModel: SpyHomeViewModel!

    override func setUp() {
        super.setUp()
        viewModel = SpyHomeViewModel()
        sut = HomeViewController(viewModel: viewModel)
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
        viewModel = nil
        super.tearDown()
    }
    
    func test_typingText_callsUpdateSearchText() {
        // Given
        let text = "Ho Chi Minh"

        // When
        sut.searchTextField.text = text
        NotificationCenter.default.post(
            name: UITextField.textDidChangeNotification,
            object: sut.searchTextField
        )

        // Then
        XCTAssertEqual(viewModel.receivedSearchTexts, [text])
    }
    
    func test_didSelectCell_callsDidSelectCity() {
        // Given
        let city = Mock.mockCity
        
        viewModel.citiesSubject.send([city])
        // Flush RunLoop.main
        RunLoop.main.run(until: Date())
        
        // When
        sut.tableView(
            sut.tableView,
            didSelectRowAt: IndexPath(row: 0, section: 0)
        )

        // Then
        XCTAssertEqual(viewModel.selectedCities, [city])
    }
}
