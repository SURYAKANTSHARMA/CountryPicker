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
    let manager: any CountryListDataSource
    @State private var filterCountries = [Country]()
    @State private var applySearch = false
    @State private var searchText = ""
    @State private var selectedCountry: Country?
    let configuration: Configuration

    private var searchResults: [Country] {
        searchText.isEmpty ? manager.allCountries([]) : filterCountries
    }

    init(manager: any CountryListDataSource = CountryManager.shared,
         configuration: Configuration) {
        self.manager = manager
        self.configuration = configuration
    }

    var body: some View {
        NavigationView {
            List(searchResults) { country in
                CountryCell(country: country,
                            isFavorite: selectedCountry == country,
                            selectedCountry: $selectedCountry,
                            configuration: configuration)
                    .onTapGesture {
                        selectedCountry = country
                    }
            }
            .searchable(text: $searchText)
            .navigationTitle("Country Picker")
            .onChange(of: searchText) { newValue in
                filterCountries = manager.filterCountries(searchText: newValue)
            }
            .onDisappear {
                manager.lastCountrySelected = selectedCountry
            }
        }
    }
}

struct CountryCell: View {
    let country: Country
    let isFavorite: Bool
    @Binding var selectedCountry: Country?
    let configuration: CountryPickerView.Configuration
    
    
    var body: some View {
        Button {
            selectedCountry = country
        } label: {
            HStack {
                if !configuration.isCountryFlagHidden {
                    switch configuration.flagStyle {
                    case .normal:
                        Image(uiImage: country.flag ?? .init())
                            .resizable()
                            .frame(width: 40, height: 26)
                            .scaledToFit()
                    case .circular:
                        Image(uiImage: country.flag ?? .init())
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())

                    case .corner:
                        Image(uiImage: country.flag ?? .init())
                            .resizable()
                            .frame(width: 40, height: 26)
                            .scaledToFit()
                            .cornerRadius(8)
                    }
                }
                VStack(alignment: .leading) {
                    Text(country.countryName)
                        .font(configuration.labelFont)
                        .foregroundColor(configuration.labelColor)

                    if !configuration.isCountryDialHidden {
                        Text(country.dialingCode ?? "")
                            .font(configuration.detailFont)
                            .foregroundColor(configuration.detailColor)
                    }
                }

                Spacer()
                if isFavorite {
                    Image(uiImage: UIImage(named: "tickMark", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate) ?? .init())
                }
            }
        }
    }
}

extension CountryPickerView {
    
    public struct Configuration {
        public var flagStyle: CountryFlagStyle = CountryFlagStyle.corner
        public var labelFont: Font = .title3
        public var labelColor: Color = .black
        public var detailFont: Font = .footnote
        public var detailColor: Color = .gray
        
        public var isCountryFlagHidden: Bool = false
        public var isCountryDialHidden: Bool = false
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
        CountryPickerView(configuration: CountryPickerView.Configuration())
    }
}
