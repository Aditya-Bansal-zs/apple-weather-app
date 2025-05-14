//
//  HomeScreen.swift
//  apple-weather-app
//
//  Created by ZopSmart on 02/04/25.
//

import SwiftUI

struct HomeScreen: View {

    @StateObject var viewModel: WeatherListViewModel

    init(initialWeathers: [WeatherCoreDataModel]) {
        _viewModel = StateObject(wrappedValue: WeatherListViewModel(
            weatherDataManager: WeatherDataManager(),
            networkManager: NetworkManager(),
            weathers: initialWeathers)
        )
    }

    var body: some View {
        TabView {
            WeatherSlidingView(viewModel: viewModel)
            .tabItem {
                Image(systemName: "sun.max.fill")
                Text("Weather")
            }

            WeatherListView(viewModel: viewModel)
            .tabItem {
                Image(systemName: "list.bullet")
                Text("More")
            }
        }.toolbarBackground(.hidden, for: .tabBar)
    }
}
