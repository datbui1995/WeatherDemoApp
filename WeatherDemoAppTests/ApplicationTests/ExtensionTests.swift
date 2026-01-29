//
//  ExtensionTests.swift
//  WeatherDemoAppTests
//
//  Created by Dat Bui on 30/1/26.
//

import XCTest
import Combine
@testable import WeatherDemoApp

final class ExtensionsTests: XCTestCase {

    private var cancellables: Set<AnyCancellable> = []

    override func tearDown() {
        cancellables.removeAll()
        super.tearDown()
    }

    // MARK: - UIViewController.className

    func test_className_returnsCorrectClassName() {
        // Given
        final class TestViewController: UIViewController {}

        // When
        let className = TestViewController.className

        // Then
        XCTAssertEqual(className, "TestViewController")
    }

    // MARK: - UITextField.textPublisher

    func test_textPublisher_emitsTextOnChange() {
        // Given
        let textField = UITextField()
        let expectation = XCTestExpectation(description: "Should emit text changes")

        var receivedValues: [String] = []

        textField.textPublisher
            .sink { value in
                receivedValues.append(value)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // When
        textField.text = "Hello"
        NotificationCenter.default.post(
            name: UITextField.textDidChangeNotification,
            object: textField
        )

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedValues, ["Hello"])
    }

    func test_textPublisher_doesNotEmitForOtherTextField() {
        // Given
        let textField = UITextField()
        let otherTextField = UITextField()

        let expectation = XCTestExpectation(description: "Should not emit")
        expectation.isInverted = true

        textField.textPublisher
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // When
        otherTextField.text = "Ignored"
        NotificationCenter.default.post(
            name: UITextField.textDidChangeNotification,
            object: otherTextField
        )

        // Then
        wait(for: [expectation], timeout: 0.5)
    }

    // MARK: - Array<StringValueResponse>.firstValue

    func test_firstValue_returnsFirstElementValue() {
        // Given
        let responses = [
            StringValueResponse(value: "First"),
            StringValueResponse(value: "Second")
        ]

        // When
        let result = responses.firstValue

        // Then
        XCTAssertEqual(result, "First")
    }

    func test_firstValue_returnsEmptyStringWhenArrayIsEmpty() {
        // Given
        let responses: [StringValueResponse] = []

        // When
        let result = responses.firstValue

        // Then
        XCTAssertEqual(result, "")
    }
}
