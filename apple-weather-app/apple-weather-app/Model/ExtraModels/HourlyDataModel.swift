//
//  HourlyDataModel.swift
//  apple-weather-app
//
//  Created by ZopSmart on 27/03/25.
//

import Foundation

struct HourlyDataModel: Codable{
    let dt: Double
    let temp: Double
    let feelsLike: Double
    let pressure: Double
    let humidity: Double
    let dewPoint: Double
    let uvi: Double
    let clouds: Double
    let visibility: Double
    let windSpeed: Double
    let windDeg: Double
    let windGust: Double
    let weather: [WeatherDataModel]
    let pop: Double
}
