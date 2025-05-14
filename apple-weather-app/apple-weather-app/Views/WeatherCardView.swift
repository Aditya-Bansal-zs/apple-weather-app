//
//  WeatherCardView.swift
//  apple-weather-app
//
//  Created by ZopSmart on 01/04/25.
//

import SwiftUI

struct WeatherCardView: View {
    var weather: WeatherCoreDataModel?
    @ObservedObject var viewModel: WeatherListViewModel
    
    var body: some View {
        HStack {
            ZStack {
                let theme = WeatherTheme(from: weather?.main ?? "")
                Image(theme.backgroundImage)
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: viewModel.isEditing ? 330 : 0, maxWidth: viewModel.isEditing ? 330 : .infinity,
                           maxHeight: viewModel.isEditing ? 140 : 150)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.black.opacity(0.3))
                    )
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.2))
                    .blur(radius: 8)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text(weather?.city ?? "")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text(viewModel.tempUnit(temp: weather?.temp))
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    Text(viewModel.formatDate(weather?.dt ?? Date()))
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.9))
                    
                    Text(weather?.weatherDescription?.capitalized ?? "")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                    
                    HStack {
                        Text("H:\(viewModel.tempUnit(temp: weather?.maxTemp))")
                        Text("L:\(viewModel.tempUnit(temp: weather?.minTemp))")
                    }
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                }
                .padding()
            }
            .frame(minWidth: viewModel.isEditing ? 330 : 0, maxWidth: viewModel.isEditing ? 330 : .infinity,
                   maxHeight: viewModel.isEditing ? 140 : 150)
            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 4)
        }
        .animation(.easeInOut, value: viewModel.isEditing)
    }
}

//#Preview {
//    let vm = WeatherListViewModel()
//    
//    WeatherCardView(viewModel: vm, weather: <#WeatherCoreDataModel#>)
//}
