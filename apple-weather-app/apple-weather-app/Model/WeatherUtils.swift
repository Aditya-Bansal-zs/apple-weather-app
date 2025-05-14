//
//  WeatherUtils.swift
//  apple-weather-app
//
//  Created by ZopSmart on 07/04/25.
//

import Foundation

enum WeatherUtils: String, CaseIterable {
    case celsius = "C"
    case fahrenheit = "F"
    
    func format(tempInCelsius: Double?) -> String {
        guard let temp = tempInCelsius else { return "--°" }
        
        switch self {
        case .celsius:
            let celsius = temp
            return String(format: "%.0f°C", celsius)
        case .fahrenheit:
            let fahrenheit = ((temp * 9) / 5) + 32
            return String(format: "%.0f°F", fahrenheit)
        }
    }
}

