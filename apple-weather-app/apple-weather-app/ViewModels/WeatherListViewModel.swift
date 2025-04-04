//
//  WeatherListViewModel.swift
//  apple-weather-app
//
//  Created by ZopSmart on 31/03/25.
//

import Foundation
import SwiftUI

struct City: Identifiable {
    var id: UUID
    var lat: Double
    var lon: Double
    var cityName: String
    var cityCountry: String
    var added: Bool = false
    init(lat: Double, lon: Double, cityName: String, cityCountry: String) {
        self.id = UUID()
        self.lat = lat
        self.lon = lon
        self.cityName = cityName
        self.cityCountry = cityCountry
    }
}
@MainActor
class WeatherListViewModel: ObservableObject {
    //Mark: - Published Variables
    @Published var weathers: [WeatherCoreDataModel] = []
    @Published var cities: [City] = []
    @Published var searchText: String = ""
    @Published var selectedCity: City?
    @Published var weatherToPass: WeatherCoreDataModel? = nil
    @Published var isEditing: Bool = false
    @Published var isCelsius: Bool = true

    //Mark: -Normal variables
    let weatherDataManager: WeatherManagerProtocol
    let networkManager: WeatherProvider
    private var timer: Timer?

//MARK: -Initializer
    init(weatherDataManager: WeatherManagerProtocol, networkManager: WeatherProvider) {
        self.weatherDataManager = weatherDataManager
        self.networkManager = networkManager
        fetchWeather()
        fetchCities()
        updateAllStoredWeathers()
        startWeatherUpdates()
    }
    
    // MARK: - Fetching weather details from core data and updating that in time interval
    func fetchWeather() {
        self.weathers = weatherDataManager.mapEntityToModel().sorted { $0.order < $1.order }
//        print("After intialization")
//        for weather in weathers {
//            print("\(weather.city ?? "Unknown") -> Order: \(weather.order)")
//        }
    }
    //MARK: - Updates weather in time intervals
    private func startWeatherUpdates(interval: TimeInterval = 300) { // 300 seconds = 5 minutes
        stopWeatherUpdates()

        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            guard let self = self else {
                print("WeatherListViewModel deallocated. Stopping updates.")
                return
            }
            
            Task { @MainActor in
                self.updateAllStoredWeathers()
            }
        }
    }
    // MARK: - Update All Stored Weathers from API
    func updateAllStoredWeathers() {
        print("Updating all stored weather locations...")

        Task { [weak self] in
            guard let self = self else { return }

            let storedWeathers = weatherDataManager.mapEntityToModel().sorted { $0.order < $1.order }
            var updatedWeathers: [WeatherCoreDataModel] = []

            await withTaskGroup(of: WeatherCoreDataModel?.self) { group in
                for storedWeather in storedWeathers {
                    group.addTask {
                        do {
                            let newWeather = try await self.networkManager.fetchWeather(
                                city: storedWeather.city ?? "Bengaluru",
                                country: storedWeather.country ?? "IND"
                            )
                            return WeatherCoreDataModel.from(
                                response: newWeather,
                                order: storedWeather.order,
                                id: storedWeather.id
                            )
                        } catch {
                            print("Failed for \(storedWeather.city ?? "Unknown"): \(error.localizedDescription)")
                            return nil
                        }
                    }
                }

                for await result in group {
                    if let weather = result {
                        updatedWeathers.append(weather)
                    }
                }
            }

            DispatchQueue.main.async {
                updatedWeathers.sort {$0.order < $1.order}
                self.updateAllWeatherData(updatedWeathers)
                self.fetchWeather()
            }
        }
        print("After updateAllStoreWeather")
        for weather in weathers {
            print("\(weather.city ?? "Unknown") -> Order: \(weather.order)")
        }
    }
    //MARK: - Update weather in core data
    private func updateAllWeatherData(_ weathers: [WeatherCoreDataModel]) {
        for weather in weathers {
            self.updateWeather(with: weather)
        }
        DispatchQueue.main.async {
            self.weathers = weathers
        }
    }
    private func updateWeather(with weather: WeatherCoreDataModel) {
        weatherDataManager.updateWeather(id: weather.id, newData: weather)
    }
    //MARK: -Stop weather updates
    private func stopWeatherUpdates() {
        timer?.invalidate()
        timer = nil
    }
    //MARK: - Move weather from one index to another and change their orders
    func moveWeather(from source: IndexSet, to destination: Int) {
        print("Before Moving")
        for weather in weathers {
            print("\(weather.city ?? "Unknown") -> Order: \(weather.order)")
        }

        weathers.move(fromOffsets: source, toOffset: destination)

        for (index, _) in weathers.enumerated() {
            weathers[index].order = Int16(index)
        }
        
        weatherDataManager.saveWeatherOrder(weathers: weathers)
//        DispatchQueue.main.async {
//            self.manager.saveWeatherOrder(weathers: self.weathers)
//            //self.weathers = self.manager.mapEntityToModel().sorted { $0.order < $1.order }
//        }
        
        print("After Moving")
        for weather in weathers {
            print("\(weather.city ?? "Unknown") -> Order: \(weather.order)")
        }
    }
    
    //MARK: - Format Data and Time
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy" // Format: Year-Month-Day
        return formatter.string(from: date)
    }
    func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss" // Format: Hours:Minutes:Seconds
        return formatter.string(from: date)
    }

    //MARK: - Delete weather at particular index
    func deleteWeatherAtIndex(at indexSet: IndexSet) {
        let validIndexes = indexSet.filter { $0 < weathers.count }
        guard !validIndexes.isEmpty else { return }
        for index in validIndexes {
            let weather = weathers[index]
            print("Deleting weather: \(weather.city ?? "Unknown") at index \(index)")
            weatherDataManager.deleteWeather(weather: weather)
        }

        weathers.remove(atOffsets: indexSet)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.weathers = self.weatherDataManager.mapEntityToModel().sorted { $0.order < $1.order }
            
//            for (index, _) in self.weathers.enumerated() {
//                self.weathers[index].order = Int16(index)
//            }
//            self.weatherDataManager.saveWeatherOrder(weathers: self.weathers)
        }
    }

    //MARK: - Fetching cities
    func fetchCities() {
        let city1 = City(lat: 40.7128, lon: -74.0060, cityName: "New York", cityCountry: "USA")
        cities.append(city1)

        let city2 = City(lat: 34.0522, lon: -118.2437, cityName: "Los Angeles", cityCountry: "USA")
        cities.append(city2)

        let city3 = City(lat: 51.5074, lon: -0.1278, cityName: "London", cityCountry: "UK")
        cities.append(city3)

        let city4 = City(lat: 48.8566, lon: 2.3522, cityName: "Paris", cityCountry: "France")
        cities.append(city4)

        let city5 = City(lat: 35.6895, lon: 139.6917, cityName: "Tokyo", cityCountry: "Japan")
        cities.append(city5)

        let city6 = City(lat: 28.6139, lon: 77.2090, cityName: "New Delhi", cityCountry: "India")
        cities.append(city6)

        let city7 = City(lat: -33.8688, lon: 151.2093, cityName: "Sydney", cityCountry: "Australia")
        cities.append(city7)

        let city8 = City(lat: 55.7558, lon: 37.6173, cityName: "Moscow", cityCountry: "Russia")
        cities.append(city8)

        let city9 = City(lat: -23.5505, lon: -46.6333, cityName: "São Paulo", cityCountry: "Brazil")
        cities.append(city9)

        let city10 = City(lat: 37.7749, lon: -122.4194, cityName: "San Francisco", cityCountry: "USA")
        cities.append(city10)
    }

    //MARK: - Fetching temperature unit(celsius or faherenite)
    func tempUnit(temp: Double?) -> String {
        guard let temp = temp else { return "Error in loading Temperature" }
        if !isCelsius {
            let newTemp = (temp*9)/5 + 32
            return "\(String(format: "%.0f", newTemp))°F"
        }
        return "\(String(format: "%.0f", temp))°C"
    }

    //MARK: - Fetching image name for card
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
    var filteredCity: [City] {
        guard !searchText.isEmpty else {
            return cities
        }
        return cities.filter{ $0.cityName.localizedCaseInsensitiveContains(searchText) }
    }
    deinit {
        Task { @MainActor in
            stopWeatherUpdates()
        }
    }
}
