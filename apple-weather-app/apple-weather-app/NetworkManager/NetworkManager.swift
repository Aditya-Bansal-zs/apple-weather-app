//
//  NetworkManager.swift
//  apple-weather-app
//
//  Created by ZopSmart on 27/03/25.
//

import Foundation


enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case noData
    case decodingError(Error)
}

class NetworkManager: WeatherProvider {
    private var baseURL: String
    private var apiKey: String
    init() {
        baseURL = "https://api.openweathermap.org/data/2.5/weather"
        apiKey = "5c6472549eb66ab69f1e7036de3f5541"
    }
//    func fetchWeatherWithCompletionHandler(lat: Double, lon: Double, units: String, completion: @escaping (Result<WeatherResponseDataModel, NetworkError>) -> Void) {
//        
//        let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=\(units)"
//        guard let url = URL(string: urlString) else{
//            completion(.failure(.invalidURL))
//            return
//        }
//        let task = URLSession.shared.dataTask(with: url) {data,response,error in
//            if let error = error {
//                completion(.failure(.decodingError(error)))
//                return
//            }
//            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else{
//                completion(.failure(.invalidResponse))
//                return
//            }
//            guard let data = data else {
//                completion(.failure(.noData))
//                return
//            }
//            do{
//                let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
//                let weatherResponse = try decoder.decode(WeatherResponseDataModel.self, from: data)
//                completion(.success(weatherResponse))
//            } catch {
//                completion(.failure(.decodingError(error)))
//            }
//        }
//        
//    }
    
    func fetchWeather(city: String, country: String) async throws -> TempWeatherResponseModel {
        let urlString = "\(baseURL)?q=\(city),\(country)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else{
            throw NetworkError.invalidURL
        }
        let (data,response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        if httpResponse.statusCode == 200 {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                return try decoder.decode(TempWeatherResponseModel.self, from: data)
            } catch {
                print(error)
                print((error.localizedDescription))
                throw NetworkError.decodingError(error)
            }
        } else {
            throw NetworkError.invalidResponse
        }
    }
    
}
