//
//  ImplHomeViewModelTests.swift
//  WeatherDemoAppTests
//
//  Created by Dat Bui on 30/1/26.
//

import XCTest
import Combine
@testable import WeatherDemoApp

final class ImplHomeViewModelTests: XCTestCase {

    private var searchUseCase: SpySearchUseCase!
    private var historyUseCase: SpyHistoryUseCase!
    private var viewModel: ImplHomeViewModel!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        cancellables = []
        searchUseCase = SpySearchUseCase()
        historyUseCase = SpyHistoryUseCase()
        viewModel = ImplHomeViewModel(
            searchUseCase: searchUseCase,
            historyUseCase: historyUseCase
        )
    }
    
    func test_init_showsHistory() {
        let city = Mock.mockCity
        historyUseCase.histories = [city]

        let exp = expectation(description: "receive history")

        viewModel.citiesPublisher
            .dropFirst()
            .sink { cities in
                XCTAssertEqual(cities.count, 1)
                XCTAssertEqual(cities.first?.name, city.name)
                exp.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [exp], timeout: 1)
        XCTAssertTrue(historyUseCase.didCallGetHistory)
    }
    
    func test_search_whitespace_only_showsHistory() {
        historyUseCase.histories = [Mock.mockCity]

        let exp = expectation(description: "history for whitespace")

        viewModel.citiesPublisher
            .dropFirst()
            .sink { cities in
                XCTAssertEqual(cities.count, 1)
                exp.fulfill()
            }
            .store(in: &cancellables)

        viewModel.updateSearchText("   ")

        wait(for: [exp], timeout: 1)
    }

    func test_search_remote_failure_returnsEmpty() {
        searchUseCase.result = .failure(NSError(domain: "test", code: 0))

        let exp = expectation(description: "empty on error")

        viewModel.citiesPublisher
            .dropFirst()
            .sink { cities in
                XCTAssertTrue(cities.isEmpty)
                exp.fulfill()
            }
            .store(in: &cancellables)

        viewModel.updateSearchText("ErrorCity")

        wait(for: [exp], timeout: 1)
    }

    func test_remoteSearchPublisher_success_emitsCities() {
        let city = Mock.mockCity
        searchUseCase.result = .success([city])

        let exp = expectation(description: "emit cities")

        viewModel.remoteSearchPublisher(query: "Hanoi")
            .sink { cities in
                XCTAssertEqual(cities, [city])
                exp.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [exp], timeout: 1)
    }

    func test_remoteSearchPublisher_failure_emitsEmpty() {
        searchUseCase.result = .failure(SpySearchUseCase.SpyError.failure)

        let exp = expectation(description: "emit empty")

        viewModel.remoteSearchPublisher(query: "Hanoi")
            .sink { cities in
                XCTAssertTrue(cities.isEmpty)
                exp.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [exp], timeout: 1)
    }


    func test_didSelect_emitsNavigation() {
        let city = Mock.mockCity
        let exp = expectation(description: "navigation")

        viewModel.navigation
            .sink { route in
                if case .detail(let selected) = route {
                    XCTAssertEqual(selected.name, city.name)
                    exp.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.didSelect(city: city)

        wait(for: [exp], timeout: 1)
    }
    
    func test_remoteSearchPublisher_forwardsQuery() {
        searchUseCase.result = .success([])

        let exp = expectation(description: "query forwarded")

        viewModel.remoteSearchPublisher(query: "Saigon")
            .sink { _ in
                XCTAssertEqual(self.searchUseCase.receivedQuery, "Saigon")
                exp.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [exp], timeout: 1)
    }
}
