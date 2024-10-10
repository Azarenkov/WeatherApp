//
//  ViewModel.swift
//  WeatherApp
//
//  Created by Алексей Азаренков on 04.10.2024.
//

import Foundation
import WeatherKit
import SwiftUI

final class ViewModel: ObservableObject {
    
    var locationManager = LocationManager()
    var weatherManager = WeatherManager()
    
    @Published var icon: String
    @Published var temperature: String
    @Published var humidity: String
    @Published var city = ""
    @Published var country = ""
    @Published var temperatureFeelsLike: String
    @Published var dailyForecast: Forecast<DayWeather>?
    @Published var hourlyForecast: Forecast<HourWeather>?
    
    init() {
        self.icon = weatherManager.icon
        self.temperature = weatherManager.temperature
        self.humidity = weatherManager.humidity
        self.temperatureFeelsLike = weatherManager.temperatureFeelsLike
    }
    
    
    @MainActor
    func updateWeatherData() {
        withAnimation {
            self.icon = weatherManager.icon
            self.temperature = weatherManager.temperature
            self.humidity = weatherManager.humidity
            self.temperatureFeelsLike = weatherManager.temperatureFeelsLike
        }
    }
    
    @MainActor
    func showData() async {
        locationManager.checkLocationAuthorization()

        if let location = locationManager.lastKnownLocation {
            await weatherManager.getWeather(lat: location.latitude, long: location.longitude)
            dailyForecast = await weatherManager.dailyForecast(lat: location.latitude, long: location.longitude)
            hourlyForecast = await weatherManager.hourlyForecast(lat: location.latitude, long: location.longitude)
            updateWeatherData()
        }
    }
    
    @MainActor
    func showCityAndCountry() async {
        locationManager.cityAndCountry { city, country in
            self.city = city ?? "-"
            self.country = country ?? "-"
        }
    }
}
