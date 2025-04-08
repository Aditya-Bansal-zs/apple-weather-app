//
//  WeatherSplashView.swift
//  apple-weather-app
//
//  Created by ZopSmart on 07/04/25.
//

import SwiftUI

struct WeatherSplashView: View {
    @StateObject private var viewModel = WeatherSplashViewModel(weatherDataManager: WeatherDataManager())
    @ObservedObject var networkMonitor = NetworkMonitor()
    @StateObject var locationManager = LocationManager()

    var body: some View {
        Group {
            if viewModel.isActive {
                HomeScreen(initialWeathers: viewModel.storedWeathers)
            } else {
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [Color.blue, Color.cyan]),
                                   startPoint: .top,
                                   endPoint: .bottom)
                        .ignoresSafeArea()

                    VStack(spacing: 20) {
                        Image(systemName: "cloud.sun.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.white)

                        Text("WeatherNow")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        Text("Fetching your weather...")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
            }
        }
        .task {
            let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "HasLaunchedBefore")

            await viewModel.loadStoredWeatherImmediately()

            if !hasLaunchedBefore && networkMonitor.isConnected {
                while locationManager.city.isEmpty {
                    try? await Task.sleep(nanoseconds: 300_000_000)
                }

                await viewModel.fetchWeatherIfFirstLaunch(
                    locationReady: true,
                    city: locationManager.city,
                    country: locationManager.country
                )
            }
            else if !networkMonitor.isConnected && viewModel.storedWeathers.count > 0 {
                viewModel.isActive = true
                HomeScreen(initialWeathers: viewModel.storedWeathers)
            }
            
            if !viewModel.storedWeathers.isEmpty && !viewModel.isActive {
                try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 sec
                viewModel.isActive = true
            }
        }
    }
}


#Preview {
    WeatherSplashView()
}
