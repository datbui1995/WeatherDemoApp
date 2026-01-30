//
//  ImplImageUseCaseTests.swift
//  WeatherDemoAppTests
//
//  Created by Dat Bui on 30/1/26.
//

import XCTest
import UIKit
@testable import WeatherDemoApp

final class ImplImageUseCaseTests: XCTestCase {

    private var repository: MockImageRepository!
    private var useCase: ImplImageUseCase!

    override func setUp() {
        super.setUp()
        repository = MockImageRepository()
        useCase = ImplImageUseCase(repository: repository)
    }

    override func tearDown() {
        repository = nil
        useCase = nil
        super.tearDown()
    }

    // MARK: - Cache hit

    func test_loadImage_returnsCachedImage_whenCacheExists() async throws {
        // Arrange
        let image = UIImage(systemName: "star")!
        repository.cachedImage = image

        // Act
        let result = try await useCase.loadImage(urlString: "url")

        // Assert
        XCTAssertEqual(result, image)
        XCTAssertEqual(repository.getCacheCalledWithKey, "url")
        XCTAssertNil(repository.loadImageCalledWithURL)
        XCTAssertNil(repository.setCacheCalledWith)
    }

    // MARK: - Cache miss + load success

    func test_loadImage_loadsFromRepository_andCachesImage_whenCacheMiss() async throws {
        // Arrange
        let image = UIImage(systemName: "star")!
        repository.cachedImage = nil
        repository.loadedImage = image

        // Act
        let result = try await useCase.loadImage(urlString: "url")

        // Assert
        XCTAssertEqual(result, image)
        XCTAssertEqual(repository.getCacheCalledWithKey, "url")
        XCTAssertEqual(repository.loadImageCalledWithURL, "url")
        XCTAssertEqual(repository.setCacheCalledWith?.image, image)
        XCTAssertEqual(repository.setCacheCalledWith?.key, "url")
    }

    // MARK: - Cache miss + load returns nil

    func test_loadImage_doesNotCache_whenLoadedImageIsNil() async throws {
        // Arrange
        repository.cachedImage = nil
        repository.loadedImage = nil

        // Act
        let result = try await useCase.loadImage(urlString: "url")

        // Assert
        XCTAssertNil(result)
        XCTAssertEqual(repository.loadImageCalledWithURL, "url")
        XCTAssertNil(repository.setCacheCalledWith)
    }

    // MARK: - Cache miss + load throws

    func test_loadImage_throwsError_whenRepositoryThrows() async {
        // Arrange
        repository.cachedImage = nil
        repository.loadError = URLError(.badServerResponse)

        // Act & Assert
        do {
            _ = try await useCase.loadImage(urlString: "url")
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? URLError, repository.loadError)
        }

        XCTAssertEqual(repository.loadImageCalledWithURL, "url")
        XCTAssertNil(repository.setCacheCalledWith)
    }
}
