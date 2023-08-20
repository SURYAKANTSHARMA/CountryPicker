//
//  ContentView.swift
//  CountryPicker13+Example
//
//  Created by Surya on 18/06/23.
//

import SwiftUI
import SKCountryPicker

struct MainView: View {
    
    @State private var selectedCountry: Country = CountryManager.shared.preferredCountry ?? Country(countryCode: "IN")
    
    @State var shouldShowDialingCode: Bool = true
    @State var shouldShowCountryFlag: Bool = true
    @State var shouldShowWithSection: Bool = true
    
    @State private var isCountryPickerPresented = false

    @State var shouldFilterByCountryCode: Bool = false
    @State var shouldFilterByDialCode: Bool = false
    

    var body: some View {
        NavigationView {
            VStack {
                
                Text("Style Controls")
                    .font(.title)
                    .bold()
                    .padding(20)
                 
                Toggle("Show Dialing Code",
                       isOn: $shouldShowDialingCode)
                .frame(width: 300, alignment: .center)
                .padding(8)
                
                Toggle("Show Country Flag",
                       isOn: $shouldShowCountryFlag)
                .frame(width: 300, alignment: .center)
                .padding(8)

                Toggle("Show With Section",
                       isOn: $shouldShowWithSection)
                .frame(width: 300, alignment: .center)
                .padding(8)
                
                
                Text("Filter Controls")
                    .font(.title)
                    .bold()
                    .padding(20)
                 
                Toggle("Filter by Country Code",
                       isOn: $shouldFilterByCountryCode)
                .frame(width: 300, alignment: .center)
                .padding(8)
                
                Toggle("Filter by dail Code",
                       isOn: $shouldFilterByDialCode)
                .frame(width: 300, alignment: .center)
                .padding(8)

                .padding(.bottom, 50)

                Button(action: {
                    isCountryPickerPresented.toggle()
                }) {
                    HStack {
                        Text(selectedCountry.dialingCode ?? "Select country")
                        Image(uiImage: selectedCountry.flag ?? .init())
                            .resizable()
                            .frame(width: 40, height: 25)
                    }
                }
                .sheet(isPresented: $isCountryPickerPresented) {
                    let configuration = Configuration(
                        isCountryFlagHidden: !shouldShowCountryFlag,
                        isCountryDialHidden: !shouldShowDialingCode)
                    
                    if shouldShowWithSection {
                        CountryPickerWithSections(
                            configuration: configuration,
                            selectedCountry: $selectedCountry)
                    } else {
                        CountryPickerView(configuration: configuration,
                                          selectedCountry: $selectedCountry)

                    }
                }
                .padding(.bottom, 50)
                
                Button(action: {
                    isCountryPickerPresented.toggle()
                }) {
                    Text("Pick Country")
                        .font(.title3)
                        .padding()
                        .padding(.horizontal)
                        .frame(minWidth: 300)
                        .bold()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10) // Apply corner radius

                }
                
                .onChange(of: shouldFilterByCountryCode) { newValue in
                    if newValue {
                        CountryManager.shared.addFilter(.countryCode)
                    } else {
                        CountryManager.shared.removeFilter(.countryCode)
                    }
                }
                .onChange(of: shouldFilterByDialCode) { newValue in
                    if newValue {
                        CountryManager.shared.addFilter(.countryDialCode)
                    } else {
                        CountryManager.shared.removeFilter(.countryDialCode)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
