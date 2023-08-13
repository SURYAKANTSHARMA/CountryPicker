//
//  ContentView.swift
//  CountryPicker13+Example
//
//  Created by Surya on 18/06/23.
//

import SwiftUI
import SKCountryPicker

struct ContentView: View {
    @State private var isCountryPickerPresented = false
    @State private var selectedCountry: Country? = CountryManager.shared.lastCountrySelected ??  CountryManager.shared.currentCountry
    
    var body: some View {
        NavigationView {
            VStack {
                Button(action: {
                    isCountryPickerPresented.toggle()
                }) {
                    HStack {
                        Text(selectedCountry?.dialingCode ?? "Select country")
                        Image(uiImage: selectedCountry?.flag ?? .init())
                            .resizable()
                            .frame(width: 40, height: 25)
                    }
                }
                .sheet(isPresented: $isCountryPickerPresented) {
//                    CountryPickerWheelView()
                    CountryPickerView(configuration: Configuration(),
                                      selectedCountry: $selectedCountry)
//                    CountryPickerWithSections()
                    
                }
                .padding(.bottom, 50)
                NavigationLink(destination:
                                CountryPickerView(configuration: Configuration(),
                                                  selectedCountry: $selectedCountry)) {
                        Text("Select country Picker")
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