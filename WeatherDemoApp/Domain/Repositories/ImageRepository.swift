//
//  ImageRepository.swift
//  WeatherDemoApp
//
//  Created by Dat Bui on 29/1/26.
//

import Foundation
import UIKit

protocol ImageRepository {
    func getCache(key: String) -> UIImage?
    func setCache(_ item: UIImage, key: String)
    func loadImage(urlString: String) async throws -> UIImage?
}
