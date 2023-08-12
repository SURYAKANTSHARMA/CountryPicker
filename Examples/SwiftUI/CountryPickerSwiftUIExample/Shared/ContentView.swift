//
//  ContentView.swift
//  Shared
//
//  Created by Suryakant on 04/01/22.
//

import SwiftUI
import CountryPicker
import Combine

struct ContentView: View {
    @State private var isShowingCountryPicker = false
    @State private var country: Country = CountryManager.shared.currentCountry ?? Country.init(countryCode: "IN")


    var body: some View {
        VStack {
            HStack {
                Image(uiImage: country.flag ?? UIImage())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32.0, height: 32.0)
                Text(country.countryName)
            }
            Button("Select Country") {
                isShowingCountryPicker = true
            }.sheet(isPresented: $isShowingCountryPicker) {
                CountryPickerViewProxy { choosenCountry in
                    country = choosenCountry
              }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


