//
//  CityCellTests.swift
//  WeatherDemoAppTests
//
//  Created by Dat Bui on 30/1/26.
//

import XCTest
import UIKit
@testable import WeatherDemoApp

final class CityCellTests: XCTestCase {
    
    private var cell: CityCell!
    
    override func setUp() {
        super.setUp()
        cell = CityCell(style: .default, reuseIdentifier: CityCell.reuseIdentifier)
    }
    
    override func tearDown() {
        cell = nil
        super.tearDown()
    }
    
    // MARK: - Init
    
    func test_reuseIdentifier_isCorrect() {
        XCTAssertEqual(CityCell.reuseIdentifier, "CityCell")
    }
    
    func test_init_setsSelectionStyleToNone() {
        XCTAssertEqual(cell.selectionStyle, .none)
    }
    
    // MARK: - Configure
    
    func test_configure_setsContentConfigurationCorrectly() {
        // Given
        let city = City(
            name: "Hanoi",
            country: "VN",
            latitude: "21.036139",
            longitude: "105.810481",
            population: "9000000"
        )
        
        // When
        cell.configure(with: city)
        
        // Then
        guard let content = cell.contentConfiguration as? UIListContentConfiguration else {
            XCTFail("Expected UIListContentConfiguration")
            return
        }
        
        XCTAssertEqual(content.text, "Hanoi, VN")
        XCTAssertEqual(content.secondaryText, "Population: 9000000")
        XCTAssertEqual(content.secondaryTextProperties.color, .secondaryLabel)
    }
    
    func test_initWithCoder_setsSelectionStyleNone() throws {
        // GIVEN
        let original = CityCell(style: .default, reuseIdentifier: nil)
        
        let data = try NSKeyedArchiver.archivedData(
            withRootObject: original,
            requiringSecureCoding: false
        )
        
        // WHEN
        let unarchiver = try NSKeyedUnarchiver(forReadingFrom: data)
        unarchiver.requiresSecureCoding = false
        
        let cell = unarchiver.decodeObject(
            of: CityCell.self,
            forKey: NSKeyedArchiveRootObjectKey
        )
        
        unarchiver.finishDecoding()
        
        // THEN
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.selectionStyle, UITableViewCell.SelectionStyle.none)
    }
}
