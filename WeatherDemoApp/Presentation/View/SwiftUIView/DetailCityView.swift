//
//  DetailCityView.swift
//  WeatherDemoApp
//
//  Created by Dat Bui on 29/1/26.
//

import SwiftUI

struct DetailCityView<ViewModel: DetailCityViewModel>: View {
    
    @StateObject private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            imageView
            VStack(alignment: .leading, spacing: 12) {
                Text(viewModel.currentWeather.description).bold()
                HStack {
                    Text("\(viewModel.currentWeather.temperature)°C").bold()
                    Text("is the temperature")
                }
                Text("Humidity is \(viewModel.currentWeather.humidity)%")
            }
        }
        .navigationBarTitle(viewModel.city.name)
        .onAppear(perform: viewModel.loadData)
        
    }
}

extension DetailCityView {
    @ViewBuilder
    private var imageView: some View {
        if let image = viewModel.uiImage {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}
