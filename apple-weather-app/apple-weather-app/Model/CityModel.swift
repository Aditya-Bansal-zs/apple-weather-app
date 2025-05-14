//
//  CityModel.swift
//  apple-weather-app
//
//  Created by ZopSmart on 08/04/25.
//

import Foundation
struct CityModel: Identifiable, Decodable, Equatable {
    let id = UUID()
    let name: String
    let country: String
    let state: String?
    let lat: Double
    let lon: Double
    enum CodingKeys: CodingKey {
        case id
        case name
        case country
        case state
        case lat
        case lon
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.country = try container.decode(String.self, forKey: .country)
        self.state = try container.decodeIfPresent(String.self, forKey: .state)
        self.lat = try container.decode(Double.self, forKey: .lat)
        self.lon = try container.decode(Double.self, forKey: .lon)
    }
}
