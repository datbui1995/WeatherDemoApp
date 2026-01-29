//
//  Endpoint.swift
//  WeatherDemoApp
//
//  Created by Dat Bui on 29/1/26.
//

import Foundation

struct Endpoint {
    let url: String
    let queryItems: [URLQueryItem]
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingFailed
}
