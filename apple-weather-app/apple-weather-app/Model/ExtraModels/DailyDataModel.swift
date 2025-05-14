//
//  DailyDataModel.swift
//  apple-weather-app
//
//  Created by ZopSmart on 27/03/25.
//

import Foundation

struct DailyDataModel: Codable{
    let dt: Double
    let sunrise: Double
    let sunset: Double
    let moonrise: Double
    let moonPhase: Double
    let summary: String
    let temp: TempDataModel
    let feelsLike: FeelsLikeDataModel
    let pressureL: Double
    let humidity: Double
    let dewPoint: Double
    let windSpeed: Double
    let windDeg: Double
    let windDustl: Double
    let weather: [WeatherDataModel]
    let clouds: Double
    let pop: Double
    let rain: Double
    let uvi: Double
}
