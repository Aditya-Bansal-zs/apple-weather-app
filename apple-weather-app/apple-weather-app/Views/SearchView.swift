//
//  SearchView.swift
//  apple-weather-app
//
//  Created by ZopSmart on 28/03/25.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel: WeatherListViewModel
    var disabling: () -> ()
    var body: some View {
        NavigationStack {
            List(viewModel.filteredCity) { city in
                Button {
                    viewModel.selectedCity = city
                    Task {
                        await viewModel.fetchWeatherFromAPI(cityName: city.cityName, cityCountry: city.cityCountry)
                    }
                } label: {
                    VStack(alignment: .leading) {
                        Text(city.cityName)
                            .font(.headline)
                        Text(city.cityCountry)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color(.systemBackground))
            .listStyle(.plain)
        }
        .sheet(item: $viewModel.selectedCity) { city in
            NavigationStack {
                WeatherView(weather: viewModel.weatherData){
                    viewModel.fetchWeather()
                    disabling()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            viewModel.selectedCity = nil
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .presentationDetents([.large])
            .ignoresSafeArea()
        }
    }
}

//#Preview {
//    let viewModel = WeatherListViewModel(weatherDataManager: WeatherDataManager(),networkManager: NetworkManager())
//    SearchView(viewModel: viewModel){}
//}
