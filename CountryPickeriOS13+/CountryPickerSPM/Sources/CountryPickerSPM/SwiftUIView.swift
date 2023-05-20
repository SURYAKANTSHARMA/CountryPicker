//
//  SwiftUIView.swift
//  
//
//  Created by Surya on 20/05/23.
//

import SwiftUI
import Combine

enum CountryFlagStyle {
    case corner
    case circular
    case normal
}



struct CountryPickerView: View {
    @StateObject private var manager = CountryManager.shared
    @State private var filterCountries = [Country]()
    @State private var applySearch = false
    @State private var searchText = ""
    @State private var selectedCountry: Country?
    
    private var searchResults: [Country] {
        if searchText.isEmpty {
            return manager.countries
        } else {
            return filterCountries
        }
    }
    
    var body: some View {
        NavigationView {
            List(searchResults) { country in
              CountryCell(country: country, isFavorite: true)
            }
//            List(searchResults) { country in
//                CountryCell(country: country, isFavorite: $manager.isFavorite(country))
//                    .onTapGesture {
//                        selectedCountry = country
//                    }
//            }
//            .searchable(text: $searchText)
//            .navigationTitle("Country Picker")
//            .onReceive(Just(searchText)) { text in
//                filterCountries = manager.filterCountriesByName(text)
//            }
//            .onDisappear {
//                if let country = selectedCountry {
//                    manager.setLastCountrySelected(country)
//                }
//            }
            
            Text("hello word ")
        }
    }
}

struct CountryCell: View {
    let country: Country
    var isFavorite: Bool
    
    var body: some View {
        HStack {
            Image(uiImage: country.flag ?? .init())
                .resizable()
                .frame(width: 40, height: 26)
                .scaledToFit()
            Text(country.countryName)
            Spacer()
            if isFavorite {
                Image(uiImage: UIImage(named: "tickMark", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate) ?? .init())
            }
        }
    }
}

//struct ContentView: View {
//    @State private var showCountryPicker = false
//    @State private var selectedCountry: Country?
//
//    var body: some View {
//        Button("Present Country Picker") {
//            showCountryPicker = true
//        }
//        .sheet(isPresented: $showCountryPicker) {
//            CountryPickerController()
//                .environmentObject(CountryManager.shared)
//                .onReceive(CountryManager.shared.$lastCountrySelected) { country in
//                    selectedCountry = country
//                    showCountryPicker = false
//                }
//        }
//    }
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CountryPickerView()
    }
}
