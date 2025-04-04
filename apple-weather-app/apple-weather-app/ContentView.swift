//
//  ContentView.swift
//  apple-weather-app
//
//  Created by ZopSmart on 27/03/25.
//

import SwiftUI

struct WeatherRow: View {
    let weather: TempWeatherResponseModel

    var body: some View {
        VStack(alignment: .leading) {
            Text(weather.name ?? "No name")
                .font(.headline)
            Text("Temperature: \(String(format: "%.1f", weather.main.temp))°C")
                .font(.subheadline)
        }
    }
}
//struct ContentView: View {
//    @StateObject var viewModel: ContentViewModel = ContentViewModel()
//    var body: some View {
//        NavigationView {
//            VStack {
//                List(viewModel.weathers, id: \.id) { weather in
//                    WeatherRow(weather: weather)
//                }
//            }
//            .navigationTitle("Weather Forecast")
//        }
//        .task {
//            do {
//                try await viewModel.fetchWeather(city: "Tonk", country: "ind")
//            } catch {
//                print(error.localizedDescription)
//                print("Error: \(error)")
//            }
//        }
//    }
//}

//#Preview {
//    ContentView()
//}
