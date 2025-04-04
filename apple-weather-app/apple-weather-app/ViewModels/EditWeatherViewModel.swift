//
//  EditWeatherViewModel.swift
//  apple-weather-app
//
//  Created by ZopSmart on 28/03/25.
//

import Foundation

class EditWeatherViewModel: ObservableObject {
    @Published var weathers: [WeatherCoreDataModel] = []
    @Published var weatherData: TempWeatherResponseModel?
    @Published var main: String? = nil

    private var networkManager: WeatherProvider
    let weatherDataManager: WeatherManagerProtocol
    var weather: WeatherCoreDataModel?

    init(weatherDataManager: WeatherManagerProtocol ,networkManager: WeatherProvider ) {
        self.weatherDataManager = weatherDataManager
        self.networkManager = networkManager
        fetchWeatherFromCoreData()
    }

    func fetchWeatherFromAPI(cityName: String, cityCountry: String) async {
        do {
            let weather = try await networkManager.fetchWeather(city: cityName, country: cityCountry)
            await MainActor.run {
                self.weatherData = weather
                self.main = weather.weather?.first?.main
            }
        } catch {
            print("Error fetching weather: \(error.localizedDescription)")
        }
    }

    func imageName(main: String) -> String {
        switch main {
        case "clear" :
            return "clear"
        case "clouds" :
            return "clouds"
        default :
            return "default"
        }
    }

    func addWeather(weather: TempWeatherResponseModel) {
        print("Before adding new weather")
        for weather in weathers {
            print("\(weather.city ?? "") \(weather.order)")
        }
        let newWeather = WeatherCoreDataModel.from(response: weather,order: Int16(weathers.count), id: UUID())
        weatherDataManager.addWeather(weather: newWeather)
        print("After adding new weather")
        for weather in weathers {
            print("\(weather.city ?? "") \(weather.order)")
        }
    }

    func isWeatherAlreadyStored() -> Bool {
        guard let weatherData = weatherData,
              let city = weatherData.name,
              let country = weatherData.sys?.country else {
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
}
