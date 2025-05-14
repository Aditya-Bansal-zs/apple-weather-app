//
//  TempDataModel.swift
//  apple-weather-app
//
//  Created by ZopSmart on 27/03/25.
//

import Foundation

struct TempDataModel: Codable{
    let day: Double
    let min: Double
    let max: Double
    let night: Double
    let eve: Double
    let morn: Double
}
