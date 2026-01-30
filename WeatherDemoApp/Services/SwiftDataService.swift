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
    
    private let context: ModelContext
    
    init(context: ModelContext = ImplSwiftDataService.makeDefaultContext()) {
        self.context = context
    }
    
    // MARK: - Public API
    func save(city: City) {
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
        var descriptor = FetchDescriptor<CityEntity>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        descriptor.fetchLimit = Constant.limitedHistory
        
        return try! context.fetch(descriptor)
    }
}

// MARK: - Factory
extension ImplSwiftDataService {
    static func makeDefaultContext() -> ModelContext {
        let container = try! ModelContainer(for: CityEntity.self)
        return ModelContext(container)
    }
}
