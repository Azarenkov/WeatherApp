//
//  ContentView.swift
//  WeatherApp
//
//  Created by Алексей Азаренков on 03.10.2024.
//

import SwiftUI
import CoreLocation

struct MainView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject private var viewModel = ViewModel()
    
    @State private var timezone: TimeZone? = .current
    
    var body: some View {
        ZStack {
            backgounds
                .ignoresSafeArea()
            ScrollView {
                
                
                VStack(spacing: 12) {
                    
                    HStack {
                        
                        InfoCard(icon: viewModel.icon, title: "Tempreture", value: viewModel.temperature)
                            .environmentObject(viewModel)
                            .frame(width: 175, height: 125)
                            .padding(.trailing)
                        
                        Spacer()
                        
                        InfoCard(icon: "location", title: "Location", city: viewModel.city, country: viewModel.country)
                            .frame(height: 125)

                        
                    }
                    .padding(.horizontal)
                    
                    
                    HStack {
                        
                        InfoCard(icon: "humidity", title: "Humidity", humidity: viewModel.humidity)
                            .frame(height: 125)
                            .padding(.trailing)

                        
                        Spacer()
                        
                        InfoCard(icon: "thermometer.medium", title: "Feels like", temperatureFeelsLike: viewModel.temperatureFeelsLike)
                            .frame(width: 125, height: 125)
                        
                    }
                    .padding()
                    
                    InfoCard(icon: "clock", title: "Hourly forecast", hourlyForecast: viewModel.hourlyForecast, timezone: timezone)
                        .frame(height: 125)
                        .padding(.horizontal)
                    
                    InfoCard(icon: "calendar", title: "Daily forecast", dailyForecast: viewModel.dailyForecast)
                        .padding(.horizontal)
                        .padding(.top)

                }
                .onAppear {
                    Task {
                        await viewModel.showData()
                        await viewModel.showCityAndCountry()
                    }
                }
            }
            
        }
    }
}

extension MainView {
    
    private var backgounds: some View {
        if colorScheme == .dark {
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 71 / 255, green: 94 / 255, blue: 126 / 255), Color(red: 0 / 255, green: 31 / 255, blue: 77 / 255)
                        ]),
                        startPoint: .topTrailing,
                        endPoint: .bottomLeading
                    )
                )
        } else {
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 132 / 255, green: 170 / 255, blue: 112 / 255), Color(red: 61 / 255, green: 107 / 255, blue: 175 / 255)
                        ]),
                        startPoint: .topTrailing,
                        endPoint: .bottomLeading
                    )
                )
        }
    }
    
}

#Preview {
    MainView()
}
