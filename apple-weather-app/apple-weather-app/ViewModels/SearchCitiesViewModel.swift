//
//  SearchCitiesViewModel.swift
//  apple-weather-app
//
//  Created by ZopSmart on 08/04/25.
//

import Foundation
import MapKit
import SwiftUI

@MainActor
class CitySearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var results: [CityModel] = []
    
    let networkManager = NetworkManager()
    
}

