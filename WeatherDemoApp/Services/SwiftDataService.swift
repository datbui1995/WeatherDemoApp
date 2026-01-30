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
    
    private let context: ModelContext?
    
    init(context: ModelContext? = nil) {
        if let context {
            self.context = context
        } else {
            self.context = Self.makeDefaultContextSafely()
        }
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
extension ImplSwiftDataService {
    static func makeDefaultContextSafely() -> ModelContext? {
        do {
            let container = try ModelContainer(for: CityEntity.self)
            return ModelContext(container)
        } catch {
            #if DEBUG
            assertionFailure("SwiftData init failed: \(error)")
            #endif
            return nil
        }
    }
}
