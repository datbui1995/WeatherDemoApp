//
//  ImageUseCase.swift
//  WeatherDemoApp
//
//  Created by Dat Bui on 29/1/26.
//

import Foundation
import UIKit

protocol ImageUseCase {
    func loadImage(urlString: String) async throws -> UIImage?
}

class ImplImageUseCase: ImageUseCase {
    private let repository: ImageRepository
    
    init(repository: ImageRepository) {
        self.repository = repository
    }
    
    func loadImage(urlString: String) async throws -> UIImage? {
        // if cache is exist
        if let cacheImage = repository.getCache(key: urlString) {
            return cacheImage
        }
        
        // load image from URL
        let image = try await repository.loadImage(urlString: urlString)
        
        if let image {
            // save image to cache
            repository.setCache(image, key: urlString)
        }

        return image
    }
}
