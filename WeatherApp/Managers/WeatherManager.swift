//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Алексей Азаренков on 03.10.2024.
//

import SwiftUI
import WeatherKit

class WeatherManager: ObservableObject {
    
    private let weatherService = WeatherService()
    var weather: Weather?
    
    
    func getWeather(lat: Double, long: Double) async {
        do {
            weather = try await Task.detached(priority: .userInitiated) { [weak self] in
                return try await self?.weatherService.weather(for: .init(latitude: lat, longitude: long))
            }.value
            
        } catch {
            print("Failed to get weather data. \(error)")
        }
    }
    
    func hourlyForecast(lat: Double, long: Double) async -> Forecast<HourWeather>? {
        let hourlyForecast = try? await Task.detached(priority: .userInitiated) {
            let forecast = try await self.weatherService.weather(for: .init(latitude: lat, longitude: long), including: .hourly)
            return forecast
        }.value
        return hourlyForecast
    }
    
    func dailyForecast(lat: Double, long: Double) async -> Forecast<DayWeather>? {
        let dailyForecast = try? await Task.detached(priority: .userInitiated) {
            let forecast = try await self.weatherService.weather(for: .init(latitude: lat, longitude: long), including: .daily)
            return forecast
        }.value
        return dailyForecast
    }

    var icon: String {
        guard let iconName = weather?.currentWeather.symbolName else { return "--" }
        
        return iconName
    }
    
    var temperature: String {
        guard let temp = weather?.currentWeather.temperature else { return "--" }
        let convert = temp.converted(to: .celsius).value
        
        return String(Int(convert)) + "°C"
    }
    
    var humidity: String {
        guard let humidity = weather?.currentWeather.humidity else { return "--" }
        let computedHumidity = humidity * 100
        
        return String(Int(computedHumidity)) + "%"
    }
    
    var temperatureFeelsLike: String {
        guard let temperatureFeelsLike = weather?.currentWeather.apparentTemperature else { return "--" }
        let convert = temperatureFeelsLike.converted(to: .celsius).value
        
        return String(Int(convert)) + "°C"
    }
        
}
