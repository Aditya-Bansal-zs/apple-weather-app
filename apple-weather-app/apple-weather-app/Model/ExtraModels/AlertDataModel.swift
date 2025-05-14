//
//  AlertDataModel.swift
//  apple-weather-app
//
//  Created by ZopSmart on 27/03/25.
//

import Foundation

struct AlertDataModel: Codable{
    let senderName: String
    let even: String
    let start: Double
    let end: Double
    let description: String
    let tags: [String]
}
