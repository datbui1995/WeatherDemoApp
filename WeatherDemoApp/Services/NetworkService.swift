//
//  NetworkService.swift
//  WeatherDemoApp
//
//  Created by Dat Bui on 28/1/26.
//

import Foundation
import Combine

protocol NetworkService {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
    func loadImage(urlString: String) async throws -> Data?
}

final class ImplNetworkService: NetworkService {

    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.session = session
        self.decoder = decoder
    }
    
    func request<T>(_ endpoint: Endpoint) async throws -> T where T : Decodable {
        let request = try makeRequest(endpoint)
        let (data, response) = try await session.data(for: request)
        try validate(response)
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed
        }
    }
    
    func loadImage(urlString: String) async throws -> Data? {
        guard let url = URL(string: urlString) else { return nil }
        let (data, _) = try await session.data(from: url)
        return data
    }
    
    private func makeRequest(_ endpoint: Endpoint) throws -> URLRequest {
        guard var components = URLComponents(string: endpoint.url) else {
            throw NetworkError.invalidURL
        }
        
        components.queryItems = endpoint.queryItems
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        return URLRequest(url: url)
    }
    
    private func validate(_ response: URLResponse) throws {
        guard let http = response as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
            throw NetworkError.invalidResponse
        }
    }
}
