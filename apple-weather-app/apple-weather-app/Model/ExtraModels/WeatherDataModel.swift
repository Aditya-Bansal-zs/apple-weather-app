//
//  WeatherDataModel.swift
//  apple-weather-app
//
//  Created by ZopSmart on 27/03/25.
//

import Foundation

struct WeatherDataModel: Codable{
    let id: Int
    let main: String
    let description: String
    let icon: String
}
