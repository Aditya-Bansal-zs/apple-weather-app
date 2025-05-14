//
//  TempWeatherResponseModel.swift
//  apple-weather-app
//
//  Created by ZopSmart on 28/03/25.
//

import Foundation

struct TempWeatherResponseModel: Codable {
    let coord: Coord?
    let weather: [Weather]?
    let base: String?
    let main: Main
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Int?
    let sys: Sys?
    let timezone, id: Int?
    let name: String?
    let cod: Int?
}
struct Clouds: Codable {
    let all: Int?
}
struct Coord: Codable {
    let lon, lat: Double?
}
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity, seaLevel, grndLevel: Int
}
struct Sys: Codable {
    let type, id: Int?
    let country: String?
    let sunrise, sunset: Int?
}
struct Weather: Codable {
    let id: Int?
    let main, description, icon: String?
}
struct Wind: Codable {
    let speed: Double?
    let deg: Int?
}
