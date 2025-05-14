//
//  WeatherCoreDataModel.swift
//  apple-weather-app
//
//  Created by ZopSmart on 28/03/25.
//

import Foundation

extension WeatherCoreDataModel {
    static func from(response: TempWeatherResponseModel,order: Int16,id: UUID?, home: Bool = false) -> WeatherCoreDataModel {
        return WeatherCoreDataModel(
            id: id ?? UUID(),  // Generate a new UUID
            timezone: Int64(response.timezone ?? 0),
            city: response.name,
            country: response.sys?.country,
            dt: response.dt != nil ? Date(timeIntervalSince1970: TimeInterval(response.dt!)) : nil,
            temp: response.main.temp,
            maxTemp: response.main.tempMax,
            minTemp: response.main.tempMin,
            sunrise: response.sys?.sunrise != nil ? Date(timeIntervalSince1970: TimeInterval(response.sys!.sunrise!)) : nil,
            sunset: response.sys?.sunset != nil ? Date(timeIntervalSince1970: TimeInterval(response.sys!.sunset!)) : nil,
            weatherDescription: response.weather?.first?.description ?? "No Description",
            windSpeed: response.wind?.speed ?? 0.0,
            main: response.weather?.first?.main ?? "Clear",
            home: home,
            order: order
        )
    }
}

struct WeatherCoreDataModel: Identifiable, Hashable, Equatable {
    var id: UUID
    var timezone: Int64
    var city: String?
    var country: String?
    var dt: Date?
    var temp: Double
    var maxTemp: Double
    var minTemp: Double
    var sunrise: Date?
    var sunset: Date?
    var weatherDescription: String?
    var windSpeed: Double
    var main: String
    var home: Bool = false
    var order: Int16
    init(id: UUID, timezone: Int64, city: String? = nil, country: String? = nil, dt: Date? = nil, temp: Double, maxTemp: Double, minTemp: Double, sunrise: Date? = nil, sunset: Date? = nil, weatherDescription: String? = nil, windSpeed: Double, main: String, home: Bool, order: Int16) {
        self.id = id
        self.timezone = timezone
        self.city = city
        self.country = country
        self.dt = dt
        self.temp = temp
        self.maxTemp = maxTemp
        self.minTemp = minTemp
        self.sunrise = sunrise
        self.sunset = sunset
        self.weatherDescription = weatherDescription
        self.windSpeed = windSpeed
        self.main = main
        self.home = home
        self.order = order
    }
}
