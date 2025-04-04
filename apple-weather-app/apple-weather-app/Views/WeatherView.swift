//
//  WeatherView.swift
//  apple-weather-app
//
//  Created by ZopSmart on 31/03/25.
//

import SwiftUI

struct WeatherView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var weatherListViewModel: WeatherListViewModel
    let cityName: String
    let cityCountry: String
    var adding: () -> ()
    
    @StateObject private var viewModel: EditWeatherViewModel = EditWeatherViewModel(weatherDataManager: WeatherDataManager(),networkManager: NetworkManager())
    
    var body: some View {
        ZStack {
            Image(viewModel.imageName(main: viewModel.weatherData?.weather?.first?.main?.lowercased() ?? "default"))
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                if let weather = viewModel.weatherData {
                    VStack(spacing: 10) {
                        // City Name
                        Text(cityName)
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.white)
                        
                        // Temperature
                        Text("\(weatherListViewModel.tempUnit(temp: weather.main.temp)) ")
                            .font(.system(size: 80, weight: .bold))
                            .foregroundColor(.white)
                        
                        // Weather Description
                        Text(weather.weather?.first?.description ?? "Sunny")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.8))
                        
                        // High & Low Temperature
                        Text("H: \(weatherListViewModel.tempUnit(temp: weather.main.tempMax))  L: \(weatherListViewModel.tempUnit(temp: weather.main.tempMin)) ")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    // Weather Details Box
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.blue.opacity(0.3))
                        .frame(width: 350, height: 100)
                        .overlay(
                            Text("Weather: \(weather.weather?.first?.main ?? "Unknown"). Wind: \(Int(weather.wind?.speed ?? 0)) km/h.")
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding()
                        )
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if !viewModel.isWeatherAlreadyStored(){
                    Button {
                        if let weather = viewModel.weatherData {
                            viewModel.addWeather(weather: weather)
                            weatherListViewModel.fetchWeather()
                            adding()
                            dismiss()
                        } else {
                            print("No weather data available")
                        }
                    } label: {
                        Text("Add")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .task {
            await viewModel.fetchWeatherFromAPI(cityName: cityName, cityCountry: cityCountry)
        }
    }
}


//#Preview {
//    WeatherView()
//}
