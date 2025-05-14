//
//  WeatherView.swift
//  apple-weather-app
//
//  Created by ZopSmart on 31/03/25.
//

import SwiftUI

struct WeatherView: View {
    @Environment(\.dismiss) private var dismiss
    let weather: WeatherCoreDataModel?
    var adding: () -> ()
    
    @StateObject private var viewModel: EditWeatherViewModel = EditWeatherViewModel(weatherDataManager: WeatherDataManager(),networkManager: NetworkManager())
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                Color.black.opacity(0.5).ignoresSafeArea()
                ProgressView("Fetching Weather...")
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .foregroundColor(.white)
                    .font(.title2)
            }
            else {
                let theme = WeatherTheme(from: weather?.main ?? "")
                Image(theme.backgroundImage)
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()
                VStack(spacing: 20) {
                    if let weather = weather {
                        VStack(spacing: 10) {
                            // City Name
                            Text(weather.city ?? "")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(.white)
                            
                            // Temperature
                            Text("\(viewModel.tempUnit(temp: weather.temp)) ")
                                .font(.system(size: 80, weight: .bold))
                                .foregroundColor(.white)
                            
                            // Weather Description
                            Text(weather.weatherDescription ?? "Sunny")
                                .font(.title2)
                                .foregroundColor(.white.opacity(0.8))
                            
                            // High & Low Temperature
                            Text("H: \(viewModel.tempUnit(temp: weather.maxTemp))  L: \(viewModel.tempUnit(temp: weather.minTemp)) ")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.blue.opacity(0.5))
                            .frame(width: 350, height: 100)
                            .overlay(
                                Text("Weather: \(weather.weatherDescription ?? "Unknown"). Wind: \(Int(weather.windSpeed)) km/h.")
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
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if !viewModel.isWeatherAlreadyStored(weather: weather){
                    Button {
                        if let weather = weather {
                            viewModel.addWeather(weather: weather)
                            dismiss()
                            adding()
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
    }
}


//#Preview {
//    WeatherView()
//}
