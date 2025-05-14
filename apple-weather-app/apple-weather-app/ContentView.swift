//
//  ContentView.swift
//  apple-weather-app
//
//  Created by ZopSmart on 27/03/25.
//

import SwiftUI
import MapKit

//struct ContentView: View {
//    @StateObject private var viewModel = CitySearchViewModel()
//
//        var body: some View {
//            VStack {
//                TextField("Search for city", text: $viewModel.searchText)
//                    .padding()
//                    .textFieldStyle(.roundedBorder)
//                    .onChange(of: viewModel.searchText) { _ in
//                        Task {
//                            await viewModel.fetchCities()
//                        }
//                    }
//
//                List(viewModel.results) { city in
//                    VStack(alignment: .leading) {
//                        Text(city.name)
//                            .font(.headline)
//                        Text("\(city.state ?? ""), \(city.country)")
//                            .font(.subheadline)
//                            .foregroundColor(.gray)
//                    }
//                }.listStyle(.plain)
//            }
//            .padding()
//        }
//}


//#Preview {
//    ContentView()
//}
