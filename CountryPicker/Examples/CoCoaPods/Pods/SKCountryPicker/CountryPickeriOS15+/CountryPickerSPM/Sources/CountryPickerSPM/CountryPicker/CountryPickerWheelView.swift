//
//  SwiftUIView.swift
//  
//
//  Created by ANKUSH BHATIA on 7/31/23.
//

import SwiftUI
public
struct CountryPickerWheelView: View {
    
    @ObservedObject public var viewModel: CountryPickerWheelViewModel
    @Binding public var selectedCountry: Country
    
    public var body: some View {
        VStack {
            Picker("", selection: $selectedCountry) {
                ForEach(viewModel.countries, id: \.self) {
                    CountryPickerWheelItem(country: $0)
                }
            }
            .pickerStyle(.wheel)
        }
        .onChange(of: selectedCountry) { 
            viewModel.dataSource.lastCountrySelected = $0
        }
        .padding()
    }
    
    public init(selectedCountry: Binding<Country>,
        viewModel: CountryPickerWheelViewModel = CountryPickerWheelViewModel()) {
        self._selectedCountry = selectedCountry
        self.viewModel = viewModel
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
        return CountryPickerWheelView(selectedCountry: .constant(.init(countryCode: "IN")))
    }
}
