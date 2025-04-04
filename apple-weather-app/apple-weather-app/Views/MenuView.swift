//
//  MenuView.swift
//  apple-weather-app
//
//  Created by ZopSmart on 02/04/25.
//

import SwiftUI

struct MenuView: View {
    @ObservedObject var viewModel: WeatherListViewModel
    var body: some View {
        Menu {
            Button(action: {
                viewModel.isEditing = true
            }) {
                Label("Edit List", systemImage: "pencil")
            }
            Divider()
            Button(action: {
                viewModel.isCelsius = true
            }) {
                Label("Celsius", systemImage: "thermometer")
            }
            .disabled(viewModel.isCelsius)

            Button(action: {
                viewModel.isCelsius = false
            }) {
                Label("Fahrenheit", systemImage: "thermometer")
            }
            .disabled(!viewModel.isCelsius)
        } label: {
            Image(systemName: "ellipsis.circle")
            .font(.title2)
            .foregroundColor(.primary)
        }
    }
}

#Preview {
    let viewModel = WeatherListViewModel(weatherDataManager: WeatherDataManager(),networkManager: NetworkManager())
    MenuView(viewModel: viewModel)
}
