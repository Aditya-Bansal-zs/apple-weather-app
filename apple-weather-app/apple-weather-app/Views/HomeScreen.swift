//
//  HomeScreen.swift
//  apple-weather-app
//
//  Created by ZopSmart on 02/04/25.
//

import SwiftUI

struct WeatherSwipeView: View {
    @ObservedObject var viewModel: WeatherListViewModel
    @ObservedObject var locationManager: LocationManager
    var body: some View {
        TabView {
            WeatherView(weatherListViewModel: viewModel, cityName: locationManager.city, cityCountry: locationManager.country, adding: {})
            ForEach(viewModel.weathers, id: \.id) { weather in
                if let cityName = weather.city,
                   let countryName = weather.country{
                    WeatherView(weatherListViewModel: viewModel, cityName: cityName, cityCountry: countryName) {
                    }
                } else {
                    Text("Unknown City")
                        .font(.title)
                        .foregroundColor(.gray)
                }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
    }
}
struct HomeScreen: View {
    @StateObject var locationManager: LocationManager = LocationManager()
    @StateObject var viewModel: WeatherListViewModel = WeatherListViewModel(weatherDataManager: WeatherDataManager(),networkManager: NetworkManager())
    var body: some View {
        TabView {
            WeatherSwipeView(viewModel: viewModel, locationManager: locationManager)
            .tabItem {
                Image(systemName: "sun.max.fill")
                Text("Weather")
            }
            MainScreenView(viewModel: viewModel)
            .tabItem {
                Image(systemName: "line.3.horizontal")
                Text("More")
            }
        }.toolbarBackground(.hidden, for: .tabBar)

//        .accentColor(.primary)
    }
}

#Preview {
    HomeScreen()
}
