//
//  WeatherSplashViewModel.swift
//  apple-weather-app
//
//  Created by ZopSmart on 07/04/25.
//

import Foundation

class WeatherSplashViewModel: ObservableObject {
    @Published var isActive = false
    @Published var storedWeathers: [WeatherCoreDataModel] = []

    private let weatherDataManager: WeatherDataManager
    private let networkManager = NetworkManager()
    private let hasLaunchedBeforeKey = "HasLaunchedBefore"

    init(weatherDataManager: WeatherDataManager) {
        self.weatherDataManager = weatherDataManager
    }

    func loadStoredWeatherImmediately() {
        let stored = weatherDataManager.mapEntityToModel()
        self.storedWeathers = stored
    }

    func fetchWeatherIfFirstLaunch(locationReady: Bool, city: String, country: String) async {
        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: hasLaunchedBeforeKey)
        guard !hasLaunchedBefore else { return }
        guard locationReady else { return }

        do {
            let weather = try await networkManager.fetchWeather(city: city, country: country)
            let newWeather = WeatherCoreDataModel.from(
                response: weather,
                order: Int16(storedWeathers.count),
                id: UUID(),
                home: true
            )
            weatherDataManager.addWeather(weather: newWeather)
            UserDefaults.standard.set(true, forKey: hasLaunchedBeforeKey)

            let updated = weatherDataManager.mapEntityToModel()
            await MainActor.run {
                self.storedWeathers = updated
                self.isActive = true
            }
        } catch {
            print("Network error: \(error.localizedDescription)")
        }
    }
}


