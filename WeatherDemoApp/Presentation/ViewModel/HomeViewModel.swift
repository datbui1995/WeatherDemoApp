//
//  HomeViewModel.swift
//  WeatherDemoApp
//
//  Created by Dat Bui on 28/1/26.
//

import Foundation
import Combine

protocol HomeViewModel {
    var citiesPublisher: AnyPublisher<[City], Never> { get }
    var navigation: PassthroughSubject<Route, Never> { get }
    func updateSearchText(_ text: String)
    func didSelect(city: City)
}

final class ImplHomeViewModel: HomeViewModel {
    
    var citiesPublisher: AnyPublisher<[City], Never> {
        $cities.eraseToAnyPublisher()
    }
    
    @Published private var cities: [City] = []
    private var cancellables = Set<AnyCancellable>()
    private let searchText = PassthroughSubject<String, Never>()
    let navigation = PassthroughSubject<Route, Never>()
    
    /// Initiate
    private let searchUseCase: SearchUseCase
    private let historyUseCase: HistoryUseCase
    init(searchUseCase: SearchUseCase, historyUseCase: HistoryUseCase) {
        self.searchUseCase = searchUseCase
        self.historyUseCase = historyUseCase
        bindSearch()
    }
    
    private func bindSearch() {
        searchText.prepend("")
            .debounce(for: .milliseconds(Constant.debouceTime), scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap { [weak self] query -> AnyPublisher<[City], Never> in
                self?.searchPublisher(query: query) ?? Just([]).eraseToAnyPublisher()
            }
            .assign(to: &$cities)
        
    }
    
    func updateSearchText(_ text: String) {
        searchText.send(text)
    }
    
    func didSelect(city: City) {
        navigation.send(.detail(city))
    }
}

extension ImplHomeViewModel {
    private func searchPublisher(query: String) -> AnyPublisher<[City], Never> {
        let trimmed = normalize(query)
        return shouldShowHistory(for: trimmed) ? historyPublisher() : remoteSearchPublisher(query: trimmed)
    }
    
    private func normalize(_ query: String) -> String {
        query.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func shouldShowHistory(for query: String) -> Bool {
        query.isEmpty
    }
    
    private func historyPublisher() -> AnyPublisher<[City], Never> {
        Just(historyUseCase.getCityHistories())
            .eraseToAnyPublisher()
    }
    
    private func remoteSearchPublisher(query: String) -> AnyPublisher<[City], Never> {
        Future { [weak self] promise in
            guard let self else { promise(.success([]))
                return
            }
            
            Task {
                do {
                    let result = try await self.searchUseCase.search(cityName: query)
                    promise(.success(result))
                } catch {
                    promise(.success([]))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
