//
//  MainScreenView.swift
//  apple-weather-app
//
//  Created by ZopSmart on 28/03/25.
//

import SwiftUI

struct MainScreenView: View {
    @ObservedObject var viewModel: WeatherListViewModel

    @State var searchText: String = ""
    @State var titleDisplayMode: NavigationBarItem.TitleDisplayMode = .automatic

    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("Search", text: $searchText)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .foregroundColor(.black)
                        .padding(.horizontal, 10)
                        .textFieldStyle(PlainTextFieldStyle())
                        .focused($isTextFieldFocused)
//                        .onChange(of: isTextFieldFocused) { _ , newValue in
//                            titleDisplayMode = newValue ? .inline : .automatic
//                        }
                        .overlay(
                            HStack {
                                Spacer()
                                if isTextFieldFocused {
                                    Button(action: {
                                        searchText = ""
                                        isTextFieldFocused = false
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
                                            .padding()
                                    }
                                }
                            }
                        )
                }
                if isTextFieldFocused {
                    SearchView(viewModel: viewModel)
                }
                if !isTextFieldFocused {
                    List {
                        ForEach(viewModel.weathers, id: \.id) { weather in
                            WeatherCardView(weather: weather, viewModel: viewModel) {
                                viewModel.fetchWeather()
                            }
                            .onTapGesture {
                                viewModel.weatherToPass = weather
                            }
                        }.onMove {
                            indices,
                            newOffset in
                            viewModel.moveWeather(from: indices, to: newOffset)
                        }.onDelete { indexSet in
                            if viewModel.isEditing {
                                viewModel.deleteWeatherAtIndex(at: indexSet)
                            }
                        }.deleteDisabled(!viewModel.isEditing)
                        .moveDisabled(!viewModel.isEditing)
                        
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Weathers")
            .navigationBarHidden(isTextFieldFocused)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if viewModel.isEditing {
                        Button("Done") {
                            viewModel.isEditing = false
                        }.foregroundColor(.blue)
                    } else {
                        MenuView(viewModel: viewModel)
                    }
                }
            }
        }
        .sheet(item: $viewModel.weatherToPass) { weather in
            NavigationStack {
                WeatherView(weatherListViewModel: viewModel, cityName: weather.city ?? "", cityCountry: weather.country ?? "") {
                    viewModel.fetchWeather()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            viewModel.weatherToPass = nil // Dismiss the sheet
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            
        }
    }
}

#Preview {
    let viewModel: WeatherListViewModel = WeatherListViewModel(weatherDataManager: WeatherDataManager(),networkManager: NetworkManager())
    MainScreenView(viewModel: viewModel)
}
