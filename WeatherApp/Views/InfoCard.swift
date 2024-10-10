//
//  InfoCard.swift
//  WeatherApp
//
//  Created by Алексей Азаренков on 08.10.2024.
//

import SwiftUI
import WeatherKit
import Foundation

struct InfoCard: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    var icon: String?
    var title: String
    var value: String?
    var city: String?
    var country: String?
    var humidity: String?
    var temperatureFeelsLike: String?
    var dailyForecast: Forecast<DayWeather>?
    var hourlyForecast: Forecast<HourWeather>?
    var timezone: TimeZone?
    
    @State private var barWidth: Double = 0
    
    var body: some View {
        ZStack {
            customRectangle
            
            VStack {
                HStack {
                    Image(systemName: icon ?? "")
                        .foregroundColor(Color(.lightGray))
                        .font(.headline)
                    Text(title)
                        .foregroundColor(Color(.lightGray))
                        .font(.subheadline)
                    Spacer()
                }
                .padding(10)
                Spacer()
            }
            
            if let value, let icon {
                
                HStack {
                    Image(systemName: icon)
                        .renderingMode(.original)
                        .symbolVariant(.fill)
                        
                    
                    Text(value)
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }
            }
            
            if let city, let country {
                VStack {
                    Text(city)
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        
                    Text(country)
                        .font(.callout)
                        .foregroundColor(.white)
                }.animation(.default)
            }
            
            if let humidity {
                Text(humidity)
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }
            
            if let temperatureFeelsLike {
                Text(temperatureFeelsLike)
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }
            
            if let dailyForecast {
                let maxDayTemp = dailyForecast.map{$0.highTemperature.value}.max() ?? 0
                let minDayTemp = dailyForecast.map{$0.lowTemperature.value}.min() ?? 0
                let tempRange = maxDayTemp - minDayTemp
                VStack {
                    ForEach(dailyForecast, id: \.date) { day in
                        Divider()

                        HStack() {
                            Text(day.date.formatted(.dateTime.weekday()))
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            HStack(spacing: 20) {
                                Image(systemName: day.symbolName)
                                    .renderingMode(.original)
                                    .symbolVariant(.fill)
                                    .font(.title3)
                                
                                Text("\(Int(day.lowTemperature.value.binade))°C")
                                    .font(.title3)
                                    .foregroundColor(.white)
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.secondary)
                                    .frame(width: 75, height: 5)
                                    .readSize { size in
                                        barWidth = size.width
                                    }
                                    .overlay {
                                        let degreeFactor = barWidth / tempRange
                                        let dayRangeWidth = (day.highTemperature.value - day.lowTemperature.value) * degreeFactor
                                        let xOffset = (day.lowTemperature.value - minDayTemp) * degreeFactor
                                        HStack {
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(
                                                    LinearGradient(
                                                        gradient: Gradient(
                                                            colors: [
                                                                .green, .orange
                                                            ]
                                                        ),
                                                        startPoint: .leading,
                                                        endPoint: .trailing
                                                    )
                                                )
                                                .frame(width: dayRangeWidth, height: 5)
                                            Spacer()
                                        }
                                        .offset(x: xOffset)
                                    }
                                
                                Text("\(Int(day.highTemperature.value.binade))°C")
                                    .font(.title3)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
                .padding(.top)
                .padding()
            }
            
            if let hourlyForecast, let timezone {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(hourlyForecast.prefix(24), id: \.date) { hour in
                            VStack() {
                                Text(hour.date.localTime(for: timezone))
                                    .font(.footnote)
                                    .bold()
                                    .foregroundColor(.white)
                                
                                Text(String(Int(hour.temperature.value.binade)) + "°C")
                                    .font(.title3)
                                    .foregroundColor(.white)
                            }
                            Divider()
                                .frame(height: 50)
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .padding(.horizontal)
            }
        }
    }

}

extension InfoCard {
    private var customRectangle: some View {
        Rectangle()
            .foregroundColor(.black)
            .opacity(0.2)
            .cornerRadius(25)
    }
}


