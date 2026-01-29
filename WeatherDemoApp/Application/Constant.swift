//
//  Constant.swift
//  WeatherDemoApp
//
//  Created by Dat Bui on 28/1/26.
//

import Foundation

enum Constant {
    static let apiKey: String = "7109f4254b394271a8e162316262801"
    static let baseURL = "https://api.worldweatheronline.com/premium/v1/"
    static let searchURL = baseURL + "search.ashx"
    static let weatherURL = baseURL + "weather.ashx"
    
    static let debouceTime: Int = 500
    static let limitedHistory: Int = 10
}
