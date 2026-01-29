//
//  Weather.swift
//  WeatherDemoApp
//
//  Created by Dat Bui on 29/1/26.
//

struct CurrentWeather: Codable, Equatable {
    let imageURL: String
    let description: String
    let temperature: String
    let humidity: String
    
    static let empty = CurrentWeather(imageURL: "", description: "", temperature: "", humidity: "")
}
