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
                    Text("\(viewModel.countries[index].countryName)")
                }
            }
            .pickerStyle(.wheel)
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
