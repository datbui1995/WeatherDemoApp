//
//  LocalCacheWeatherRepository.swift
//  WeatherDemoApp
//
//  Created by Dat Bui on 30/1/26.
//

import Foundation


final class LocalCacheWeatherRepository: WeatherCacheRepository {
    
    private let cache = NSCache<NSString, CacheItem>()
    private let ttl: TimeInterval = 60
    
    func get(key: String) -> CurrentWeather? {
        let nsKey = key as NSString
        
        guard let cacheItem = cache.object(forKey: nsKey) else {
            return nil
        }
        
        if cacheItem.isExpired {
            cache.removeObject(forKey: nsKey)
            return nil
        }
        
        return cacheItem.value
    }
    
    func set(_ value: CurrentWeather, for key: String) {
        let entry = CacheItem(
            value: value,
            expiry: Date().addingTimeInterval(ttl)
        )
        cache.setObject(entry, forKey: key as NSString)
    }
}

private final class CacheItem {
    let value: CurrentWeather
    let expiry: Date
    
    init(value: CurrentWeather, expiry: Date) {
        self.value = value
        self.expiry = expiry
    }
    
    var isExpired: Bool {
        Date() >= expiry
    }
}
