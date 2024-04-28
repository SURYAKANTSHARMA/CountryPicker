//
//  CountryPickerWheelDemoView.swift
//  CountryPicker13+Example
//
//  Created by ANKUSH BHATIA on 8/13/23.
//

import SwiftUI
import SKCountryPicker

struct CountryPickerWheelDemoView: View {
    
    @State private var selectedCountry: Country = CountryManager.shared.preferredCountry ?? Country(countryCode: "IN")
    
    var body: some View {
        VStack {
            VStack {
                Text("Select a Country:")
                    .font(.title)
                    .bold()
                    .padding(20)

                HStack {
                    Text(selectedCountry.dialingCode ?? "Select country")
                    Image(uiImage: selectedCountry.flag ?? .init())
                        .resizable()
                        .frame(width: 40, height: 25)
                }.padding(20)
            }
            CountryPickerWheelView(selectedCountry: $selectedCountry)
        }.padding()
        
    }
}

struct CountryPickerWheelDemoView_Previews: PreviewProvider {
    static var previews: some View {
        CountryPickerWheelDemoView()
    }
}
