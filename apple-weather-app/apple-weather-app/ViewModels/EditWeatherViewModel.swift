//
//  EditWeatherViewModel.swift
//  apple-weather-app
//
//  Created by ZopSmart on 28/03/25.
//

import Foundation

class EditWeatherViewModel: ObservableObject {
    var weathers: [WeatherCoreDataModel] = []
    @Published var weatherData: TempWeatherResponseModel?
    @Published var main: String? = nil
    @Published var isLoading: Bool = false
    private var networkManager: WeatherProvider
    let weatherDataManager: WeatherManagerProtocol
    var weather: WeatherCoreDataModel?
    init(weatherDataManager: WeatherManagerProtocol ,networkManager: WeatherProvider ) {
        self.weatherDataManager = weatherDataManager
        self.networkManager = networkManager
        fetchWeatherFromCoreData()
    }

    func addWeather(weather: WeatherCoreDataModel) {
        print("Before adding new weather")
        for weather in weathers {
            print("\(weather.city ?? "") \(weather.order)")
        }
        weatherDataManager.addWeather(weather: weather)
        print("After adding new weather")
        for weather in weathers {
            print("\(weather.city ?? "") \(weather.order)")
        }
    }

    func isWeatherAlreadyStored(weather: WeatherCoreDataModel?) -> Bool {
        guard let weather = weather,
              let city = weather.city,
              let country = weather.country else {
            return false
        }

        return weathers.contains { $0.city == city && $0.country == country }
    }

    func deleteWeather(weather: WeatherCoreDataModel?){
        guard let weather = weather else { return }
        weatherDataManager.deleteWeather(weather: weather)
    }

    func fetchWeatherFromCoreData() {
        weathers = weatherDataManager.mapEntityToModel().sorted { $0.order < $1.order }
    }

    func tempUnit(temp: Double?) -> String {
        guard let temp = temp else { return "Error in loading Temperature" }
        let saved = UserDefaults.standard.string(forKey: "tempUnit") ?? WeatherUtils.celsius.rawValue
        let unit = WeatherUtils(rawValue: saved) ?? .celsius
        return unit.format(tempInCelsius: temp)
    }
}
