//
//  WeatherSlidingView.swift
//  apple-weather-app
//
//  Created by ZopSmart on 08/04/25.
//

import SwiftUI

struct WeatherSlidingView: View {
    @ObservedObject var viewModel: WeatherListViewModel

    var body: some View {
        TabView {
            ForEach(viewModel.weathers, id: \.id) { weather in
                WeatherView(weather: weather, adding: {})
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .ignoresSafeArea()
    }
}

#Preview {
    // WeatherSlidingView(viewModel: <#WeatherListViewModel#>)
}
