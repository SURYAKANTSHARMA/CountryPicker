//
//  SwiftUIView.swift
//  
//
//  Created by ANKUSH BHATIA on 7/31/23.
//

import SwiftUI

struct CountryPickerWheelView: View {
    
    @ObservedObject var viewModel: CountryPickerWheelViewModel
    
    var body: some View {
        VStack {
            Picker("", selection: $viewModel.selected) {
                ForEach(0..<viewModel.countries.count,
                        id: \.self) { index in
                    CountryPickerWheelItem(country: viewModel.countries[index])
                }
            }
            .pickerStyle(.wheel)
        }
        
    }
}

struct CountryPickerWheelItem: View {
    
    let country: Country
    
    var body: some View {
        HStack {
            Image(uiImage: country.flag ?? UIImage())
                .resizable()
                .scaledToFit()
                .frame(width: 32.0, height: 32.0)
            Text("\(country.countryName)")
        }
    }
}

struct CountryPickerWheelView_Previews: PreviewProvider {
    static var previews: some View {
        let manager = CountryManager.shared
        let viewModel = CountryPickerWheelViewModel(countries: manager.allCountries([]),
                                                    selected: 0)
        return CountryPickerWheelView(viewModel: viewModel)
    }
}
