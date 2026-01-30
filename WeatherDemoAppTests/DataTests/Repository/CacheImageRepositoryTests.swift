//
//  CacheImageRepositoryTests.swift
//  WeatherDemoAppTests
//
//  Created by Dat Bui on 30/1/26.
//

import XCTest
@testable import WeatherDemoApp

final class CacheImageRepositoryTests: XCTestCase {

    private var networkService: MockNetworkService!
    private var repository: CacheImageRepository!

    override func setUp() {
        super.setUp()
        networkService = MockNetworkService()
        repository = CacheImageRepository(networkService: networkService)
    }

    override func tearDown() {
        networkService = nil
        repository = nil
        super.tearDown()
    }

    // MARK: - Cache tests

    func test_setCache_thenGetCache_returnsImage() {
        // Arrange
        let key = "image-key"
        let image = UIImage(systemName: "star")!

        // Act
        repository.setCache(image, key: key)
        let cachedImage = repository.getCache(key: key)

        // Assert
        XCTAssertNotNil(cachedImage)
        XCTAssertEqual(cachedImage?.pngData(), image.pngData())
    }

    func test_getCache_returnsNil_whenCacheEmpty() {
        // Act
        let image = repository.getCache(key: "missing-key")

        // Assert
        XCTAssertNil(image)
    }

    // MARK: - Network image loading

    func test_loadImage_returnsUIImage_whenNetworkReturnsValidData() async throws {
        // Arrange
        let url = "https://image.test/icon.png"
        let image = UIImage(systemName: "heart")!
        let data = image.pngData()!

        networkService.loadImageResult = .success(data)

        // Act
        let result = try await repository.loadImage(urlString: url)

        // Assert
        XCTAssertEqual(networkService.loadImageCalledWithURL, url)
        XCTAssertNotNil(result)
        XCTAssertNotNil(result?.cgImage)

    }

    func test_loadImage_returnsNil_whenNetworkReturnsNilData() async throws {
        // Arrange
        networkService.loadImageResult = .success(nil)

        // Act
        let result = try await repository.loadImage(urlString: "url")

        // Assert
        XCTAssertNil(result)
    }

    func test_loadImage_throwsError_whenNetworkThrows() async {
        // Arrange
        networkService.loadImageResult = .failure(URLError(.badURL))

        // Act / Assert
        await XCTAssertThrowsErrorAsync {
            _ = try await self.repository.loadImage(urlString: "url")
        }
    }
}


final class MockNetworkService: NetworkService {

    var loadImageResult: Result<Data?, Error>?
    private(set) var loadImageCalledWithURL: String?

    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        fatalError("Not needed for CacheImageRepository tests")
    }

    func loadImage(urlString: String) async throws -> Data? {
        loadImageCalledWithURL = urlString

        guard let loadImageResult else {
            fatalError("loadImageResult not set")
        }

        return try loadImageResult.get()
    }
}
