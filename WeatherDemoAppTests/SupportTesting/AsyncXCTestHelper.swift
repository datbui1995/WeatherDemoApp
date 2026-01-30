//
//  AsyncXCTestHelper.swift
//  WeatherDemoApp
//
//  Created by Dat Bui on 30/1/26.
//

import XCTest

func XCTAssertThrowsErrorAsync(
    _ expression: @escaping () async throws -> Void,
    file: StaticString = #filePath,
    line: UInt = #line
) async {
    do {
        try await expression()
        XCTFail("Expected error to be thrown", file: file, line: line)
    } catch {
        // Success: error was thrown
    }
}
