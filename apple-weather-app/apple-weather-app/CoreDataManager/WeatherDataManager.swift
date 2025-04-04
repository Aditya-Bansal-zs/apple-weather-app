//
//  WeatherDataManager.swift
//  apple-weather-app
//
//  Created by ZopSmart on 28/03/25.
//
import CoreData
import Foundation

protocol WeatherManagerProtocol {
    func addWeather(weather: WeatherCoreDataModel)
    func deleteWeather(weather: WeatherCoreDataModel)
    func updateWeather(id: UUID, newData: WeatherCoreDataModel)
    func saveWeatherOrder(weathers: [WeatherCoreDataModel]) // changeWeatherOrder
    func mapEntityToModel() -> [WeatherCoreDataModel] // covertToWeaterData
}

class WeatherDataManager: WeatherManagerProtocol {

    var container: NSPersistentContainer
    var context: NSManagedObjectContext

    init() {
        container =  NSPersistentContainer(name: "WeatherDatabase")
        container.loadPersistentStores { description, error in
            if let error {
                print("Error in initialize the container \(error.localizedDescription)")
                return
            }
        }
        context = container.viewContext
    }

    private func fetchWeather() -> [WeatherEntity] {
        let request = NSFetchRequest<WeatherEntity>(entityName: "WeatherEntity")
        request.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
        do {
            return try context.fetch(request)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    func addWeather(weather: WeatherCoreDataModel){
        let newWeather = WeatherEntity(context: context)
        newWeather.id = weather.id
        newWeather.timezone = weather.timezone
        newWeather.city = weather.city
        newWeather.country = weather.country
        newWeather.dt = weather.dt
        newWeather.temp = weather.temp
        newWeather.maxTemp = weather.maxTemp
        newWeather.minTemp = weather.minTemp
        newWeather.sunrise = weather.sunrise
        newWeather.sunset = weather.sunset
        newWeather.weatherDescription = weather.weatherDescription
        newWeather.windSpeed = weather.windSpeed
        newWeather.home = weather.home
        newWeather.main = weather.main
        newWeather.order = weather.order
        save()
    }
    func saveWeatherOrder(weathers: [WeatherCoreDataModel]) {
        for (index, weather) in weathers.enumerated() {
            if let storedWeather = fetchWeatherEntity(id: weather.id) {
                storedWeather.order = Int16(index)
            }
        }
        save()
    }

    private func fetchWeatherEntity(id: UUID) -> WeatherEntity? {
        let request: NSFetchRequest<WeatherEntity> = WeatherEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        do {
            return try context.fetch(request).first
        } catch {
            print("Failed to fetch weather entity: \(error.localizedDescription)")
            return nil
        }
    }
    func deleteWeather(weather: WeatherCoreDataModel) {
        let fetchRequest: NSFetchRequest<WeatherEntity> = WeatherEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", weather.id as NSUUID)

        do {
            let results = try context.fetch(fetchRequest)
            if let weatherEntity = results.first {
                print("\(weatherEntity.city ?? "") \(weatherEntity.order)")
                context.delete(weatherEntity)
                try context.save()
                reorderWeather()
                print("Weather deleted successfully.")
            } else {
                print("Weather not found in Core Data.")
            }
        } catch {
            print("Error deleting weather: \(error.localizedDescription)")
        }
    }

    private func reorderWeather() {
        let results = fetchWeather() // Get latest order from Core Data
        for (index, entity) in results.enumerated() {
            entity.order = Int16(index)
        }
        save()
    }
    
    func updateWeather(id: UUID, newData: WeatherCoreDataModel) {
        let request: NSFetchRequest<WeatherEntity> = WeatherEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
            if let entity = try context.fetch(request).first {
                entity.timezone = newData.timezone
                entity.city = newData.city
                entity.country = newData.country
                entity.dt = newData.dt
                entity.temp = newData.temp
                entity.maxTemp = newData.maxTemp
                entity.minTemp = newData.minTemp
                entity.sunrise = newData.sunrise
                entity.sunset = newData.sunset
                entity.weatherDescription = newData.weatherDescription
                entity.windSpeed = newData.windSpeed
                entity.home = newData.home
                entity.main = newData.main
                entity.order = newData.order
                save()
            }
        } catch {
            print("Failed to update: \(error)")
        }
    }
    func mapEntityToModel() -> [WeatherCoreDataModel] {
        return fetchWeather().compactMap { entity in
            guard let storedID = entity.id else {
                print(" Found AddressEntity with nil ID, skipping")
                return nil
            }
            return WeatherCoreDataModel(
                id: storedID,
                timezone: entity.timezone,
                city: entity.city ,
                country: entity.country,
                dt: entity.dt,
                temp: entity.temp ,
                maxTemp: entity.maxTemp,
                minTemp: entity.minTemp,
                sunrise: entity.sunrise,
                sunset: entity.sunset,
                weatherDescription: entity.weatherDescription,
                windSpeed: entity.windSpeed,
                main: entity.main ?? "No weather",
                home: entity.home,
                order: entity.order 
            )
        }.sorted { $0.order < $1.order }
    }

    private func updateWeatherData(with weather: WeatherCoreDataModel) {
        let fetchRequest: NSFetchRequest<WeatherEntity> = WeatherEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", weather.id as NSUUID)
        do {
                let results = try context.fetch(fetchRequest)
                if let storedWeather = results.first {
                    // Update existing weather data
                    storedWeather.timezone = weather.timezone
                    storedWeather.city = weather.city
                    storedWeather.country = weather.country
                    storedWeather.dt = weather.dt
                    storedWeather.temp = weather.temp
                    storedWeather.maxTemp = weather.maxTemp
                    storedWeather.minTemp = weather.minTemp
                    storedWeather.sunrise = weather.sunrise
                    storedWeather.sunset = weather.sunset
                    storedWeather.weatherDescription = weather.weatherDescription
                    storedWeather.windSpeed = weather.windSpeed
                    storedWeather.main = weather.main
                    storedWeather.home = weather.home
                    
                    try context.save() // Save changes
                    print(" Weather updated successfully!")
                } else {
                    print(" Weather entry not found!")
                }
            } catch {
                print(" Error updating weather: \(error.localizedDescription)")
            }
        }
    
    
    func save() {
        do {
            try context.save()
            print("Save data to core model successfully.")
        } catch {
            print("Error in saving data to core model. \(error.localizedDescription)")
        }
    }
}
