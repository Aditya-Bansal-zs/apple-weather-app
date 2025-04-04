//
//  WeatherProvider.swift
//  apple-weather-app
//
//  Created by ZopSmart on 28/03/25.
//

import Foundation

protocol WeatherProvider {
    func fetchWeather(city: String,country: String) async throws-> TempWeatherResponseModel
}
