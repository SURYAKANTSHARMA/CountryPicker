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
            Picker("Select Country", selection: $selectedCountry) {
                ForEach(viewModel.countries, id: \.self) {
                    CountryPickerWheelItem(country: $0)
                }
            }
            .pickerStyle(.wheel)
            .accessibilityLabel("Country Picker")
            .accessibilityHint("Swipe up or down to change country selection")
        }
        .onChange(of: selectedCountry) { newCountry in
            viewModel.dataSource.lastCountrySelected = newCountry
            // Announce the selection for VoiceOver users
            UIAccessibility.post(notification: .announcement, argument: "Selected \(newCountry.countryName)")
        }
        .padding()
    }
    
    @MainActor
    public init(selectedCountry: Binding<Country>, viewModel: CountryPickerWheelViewModel? = nil) {
        self._selectedCountry = selectedCountry
        self.viewModel = viewModel ?? CountryPickerWheelViewModel()
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
                .accessibilityLabel(country.countryName)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(country.countryName), flag of \(country.countryName)")
    }
}

struct CountryPickerWheelView_Previews: PreviewProvider {
    static var previews: some View {
        return CountryPickerWheelView(selectedCountry: .constant(.init(countryCode: "IN")))
    }
}
