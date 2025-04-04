//
//  WeatherResponseDataModel.swift
//  apple-weather-app
//
//  Created by ZopSmart on 27/03/25.
//

import Foundation

struct WeatherResponseDataModel: Codable{
    let lat: Double?
    let lon: Double?
    let timezone: String
    let current: CurrentWeatherDataModel
    let minutely: [MinutelyDataModel]
    let hourly: [HourlyDataModel]
    let daily: [DailyDataModel]
    let alerts: [AlertDataModel]
}
