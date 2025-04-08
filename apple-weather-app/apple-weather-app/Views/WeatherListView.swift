//
//  WeatherListView.swift
//  apple-weather-app
//
//  Created by ZopSmart on 28/03/25.
//

import SwiftUI

struct WeatherListView: View {
    @ObservedObject var viewModel: WeatherListViewModel
    @State var searchText: String = ""
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
                    SearchView(viewModel: viewModel) {
                        searchText = ""
                        isTextFieldFocused = false
                    }
                }
                if !isTextFieldFocused {
                    if viewModel.weathers.count == 0 {
                        Text("No Weathers")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.primary)
                    } else {
                        List {
                            if let homeWeather = viewModel.weathers.first {
                                WeatherCardView(weather: homeWeather, viewModel: viewModel)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        viewModel.weatherToPass = homeWeather
                                    }
                                    .listRowSeparator(.hidden)
                            }
                            ForEach(Array(viewModel.weathers.dropFirst().enumerated()), id: \.1.id) { index, weather in
                                WeatherCardView(weather: weather, viewModel: viewModel)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        viewModel.weatherToPass = weather
                                    }
                            }.onMove {
                                indices,
                                newOffset in
                                viewModel.moveWeather(from: indices, to: newOffset)
                            }.onDelete { indexSet in
                                if viewModel.isEditing {
                                    viewModel.indexSetToDelete = indexSet
                                    viewModel.showDeleteAlert = true
                                }
                            }.deleteDisabled(!viewModel.isEditing)
                            .moveDisabled(!viewModel.isEditing)
                            
                        }.environment(\.editMode, .constant(viewModel.isEditing ? .active : .inactive))
                        .listStyle(.plain)
                        .alert("Are you sure you want to delete this weather card?", isPresented: $viewModel.showDeleteAlert, actions: {
                            Button("Delete", role: .destructive) {
                                if let indexSet = viewModel.indexSetToDelete {
                                    viewModel.deleteWeatherAtIndex(at: indexSet)
                                    viewModel.fetchWeather()
                                }
                            }
                            Button("Cancel", role: .cancel) {
                                viewModel.indexSetToDelete = nil
                            }
                        })
                    }
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
                WeatherView(weather: viewModel.weatherToPass) {
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

//#Preview {
//    let viewModel: WeatherListViewModel = WeatherListViewModel(weatherDataManager: WeatherDataManager(),networkManager: NetworkManager())
//    WeatherListView(viewModel: viewModel)
//}
