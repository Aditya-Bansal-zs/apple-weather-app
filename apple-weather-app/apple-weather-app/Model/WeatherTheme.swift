//
//  WeatherTheme.swift
//  apple-weather-app
//
//  Created by ZopSmart on 04/04/25.
//

import SwiftUI

extension WeatherTheme {
    init(from string: String) {
        self = WeatherTheme(rawValue: string) ?? .unknown
    }
}

enum WeatherTheme: String {
    case clear = "Clear"
    case cloudy = "Clouds"
    case fog = "Fog"
    case rainy = "Rain"
    case snowfall = "Snow"
    case stormy = "Thunderstorm"
    case empty = ""
    case unknown
    
    var weatherType: String {
        switch self {
        case .clear, .cloudy, .fog, .rainy, .snowfall, .stormy:
            return "Mostly \(self)"
        case .unknown:
            return "Unknown"
        case .empty:
            return "No weather"
        }
    }
    var backgroundImage: String {
        switch self {
        case .clear:
            "clear"
        case .cloudy:
            "clouds"
        case .empty:
            "default"
        case .fog:
            "fog"
        case .rainy:
            "rainy"
        case .snowfall:
            "snowfall"
        case .stormy:
            "stormy"
        case .unknown:
            "default"
        
        }
    }
    
    var descriptionBGColor: Color { // TODO: Customize it ..
        switch self {
        case .clear:
            return Color.blue
        case .cloudy:
            return Color.gray
        case .empty:
            return Color.gray
        case .fog:
            return Color.gray
        case .rainy:
            return Color.gray
        case .snowfall:
            return Color.gray
        case .stormy:
            return Color.gray
        case .unknown:
            return Color.gray
        
        }
    }

    var description: String {
        "" // TODO: For enhancemnt.....
    }
}
