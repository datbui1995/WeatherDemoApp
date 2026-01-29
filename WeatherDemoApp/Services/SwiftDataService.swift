//
//  SwiftDataService.swift
//  WeatherDemoApp
//
//  Created by Dat Bui on 29/1/26.
//

import Foundation
import SwiftData

protocol SwiftDataService {
    func save(city: City)
    func fetchCities() throws -> [CityEntity]
}

final class ImplSwiftDataService: SwiftDataService {

    // This is for testing purpose
    private let injectedContext: ModelContext?
    private lazy var lazyContext: ModelContext? = {
        guard injectedContext == nil else { return nil }
        return try? Self.makeDefaultContext()
    }()

    private var context: ModelContext? {
        injectedContext ?? lazyContext
    }

    init(context: ModelContext? = nil) {
        self.injectedContext = context
    }

    // MARK: - Public API
    func save(city: City) {
        guard let context else { return }

        let descriptor = FetchDescriptor<CityEntity>(
            predicate: #Predicate {
                $0.name == city.name && $0.country == city.country
            }
        )

        if let existing = try? context.fetch(descriptor).first {
            existing.createdAt = Date()
        } else {
            context.insert(CityEntity(city: city))
        }

        try? context.save()
    }

    func fetchCities() -> [CityEntity] {
        guard let context else { return [] }

        var descriptor = FetchDescriptor<CityEntity>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        descriptor.fetchLimit = Constant.limitedHistory

        return (try? context.fetch(descriptor)) ?? []
    }
}

// MARK: - Factory
private extension ImplSwiftDataService {
    static func makeDefaultContext() throws -> ModelContext {
        let container = try ModelContainer(for: CityEntity.self)
        return ModelContext(container)
    }
}
