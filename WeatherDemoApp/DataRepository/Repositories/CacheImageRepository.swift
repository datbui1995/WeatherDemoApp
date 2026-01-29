//
//  CacheImageRepository.swift
//  WeatherDemoApp
//
//  Created by Dat Bui on 29/1/26.
//

import Foundation
import UIKit

final class CacheImageRepository: ImageRepository {
    private let cacheImage = NSCache<NSString, UIImage>()
    private let networkService: NetworkService
    
    init (networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func getCache(key: String) -> UIImage? {
        cacheImage.object(forKey: key as NSString)
    }
    
    func setCache(_ item: UIImage, key: String) {
        cacheImage.setObject(item, forKey: key as NSString)
    }
    
    func loadImage(urlString: String) async throws -> UIImage? {
        guard let data = try await networkService.loadImage(urlString: urlString) else { return nil }
        let image = UIImage(data: data)
        return image
    }

}


