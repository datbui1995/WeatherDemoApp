//
//  MockImageUseCase.swift
//  WeatherDemoAppTests
//
//  Created by Dat Bui on 30/1/26.
//


import UIKit
@testable import WeatherDemoApp

final class MockImageRepository: ImageRepository {

    // MARK: - Configurable outputs

    var cachedImage: UIImage?
    var loadedImage: UIImage?
    var loadError: URLError?

    // MARK: - Call tracking

    private(set) var getCacheCalledWithKey: String?
    private(set) var setCacheCalledWith: (image: UIImage, key: String)?
    private(set) var loadImageCalledWithURL: String?

    func getCache(key: String) -> UIImage? {
        getCacheCalledWithKey = key
        return cachedImage
    }

    func setCache(_ item: UIImage, key: String) {
        setCacheCalledWith = (item, key)
    }

    func loadImage(urlString: String) async throws -> UIImage? {
        loadImageCalledWithURL = urlString

        if let error = loadError {
            throw error
        }
        return loadedImage
    }
}

