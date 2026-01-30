//
//  EntityTests.swift
//  WeatherDemoAppTests
//
//  Created by Dat Bui on 30/1/26.
//

import XCTest
import SwiftData
@testable import WeatherDemoApp

@MainActor
final class CityEntityTests: SwiftDataTestCase {
    
    // MARK: - Designated initializer
    func test_init_setsAllPropertiesCorrectly() {
        let entity = CityEntity(
            id: "custom-id",
            name: "Hanoi",
            country: "VN",
            latitude: "21.03",
            longitude: "105.81",
            population: "9000000"
        )
        
        XCTAssertEqual(entity.id, "custom-id")
        XCTAssertEqual(entity.name, "Hanoi")
        XCTAssertEqual(entity.country, "VN")
        XCTAssertEqual(entity.latitude, "21.03")
        XCTAssertEqual(entity.longitude, "105.81")
        XCTAssertEqual(entity.population, "9000000")
        XCTAssertNotNil(entity.createdAt)
    }
    
    // MARK: - Auto-generated values
    
    func test_init_generatesUniqueIdByDefault() {
        let entity1 = CityEntity(
            name: "Hanoi",
            country: "VN",
            latitude: "21.03",
            longitude: "105.81",
            population: "9000000"
        )
        
        let entity2 = CityEntity(
            name: "HCM",
            country: "VN",
            latitude: "10.77",
            longitude: "106.69",
            population: "8000000"
        )
        
        XCTAssertNotEqual(entity1.id, entity2.id)
    }
    
    func test_createdAt_isSetToCurrentTime() {
        let before = Date()
        
        let entity = CityEntity(
            name: "Hanoi",
            country: "VN",
            latitude: "21.03",
            longitude: "105.81",
            population: "9000000"
        )
        
        let after = Date()
        
        XCTAssertTrue(entity.createdAt >= before)
        XCTAssertTrue(entity.createdAt <= after)
    }
    
    // MARK: - Convenience initializer
    
    func test_convenienceInit_fromCity_setsCorrectValues() {
        let city = City(
            name: "Hanoi",
            country: "VN",
            latitude: "21.036139",
            longitude: "105.810481",
            population: "9000000"
        )
        
        let entity = CityEntity(city: city)
        
        XCTAssertEqual(entity.name, city.name)
        XCTAssertEqual(entity.country, city.country)
        XCTAssertEqual(entity.latitude, city.latitude)
        XCTAssertEqual(entity.longitude, city.longitude)
        XCTAssertEqual(entity.population, city.population)
    }
    
    // MARK: - SwiftData integration sanity check
    
    func test_entity_canBeInsertedAndSaved() throws {
        let entity = CityEntity(
            name: "Hanoi",
            country: "VN",
            latitude: "21.03",
            longitude: "105.81",
            population: "9000000"
        )
        
        context.insert(entity)
        try context.save()
        
        let descriptor = FetchDescriptor<CityEntity>()
        let results = try context.fetch(descriptor)
        
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.name, "Hanoi")
    }
    
    func test_displayedName_withCountry() {
        // GIVEN
        let city = City(
            name: "Berlin",
            country: "Germany",
            latitude: "",
            longitude: "",
            population: ""
        )
        
        // WHEN
        let displayedName = city.displayedName
        
        // THEN
        XCTAssertEqual(displayedName, "Berlin, Germany")
    }
    
    func test_displayedName_withoutCountry() {
        // GIVEN
        let city = City(
            name: "Singapore",
            country: "",
            latitude: "",
            longitude: "",
            population: ""
        )
        
        // WHEN
        let displayedName = city.displayedName
        
        // THEN
        XCTAssertEqual(displayedName, "Singapore")
    }
}

class SwiftDataTestCase: XCTestCase {

    var modelContainer: ModelContainer!
    var context: ModelContext!

    override func setUpWithError() throws {
        let schema = Schema([
            CityEntity.self
        ])

        let configuration = ModelConfiguration(
            isStoredInMemoryOnly: true
        )

        modelContainer = try ModelContainer(
            for: schema,
            configurations: [configuration]
        )

        context = ModelContext(modelContainer)
    }
}
