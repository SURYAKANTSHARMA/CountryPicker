//
//  SwiftUIView.swift
//  
//
//  Created by Surya on 20/05/23.
//

import SwiftUI
import Combine

public
enum CountryFlagStyle {
    case corner
    case circular
    case normal
}

public
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

    public
    init(manager: any CountryListDataSource = CountryManager.shared,
         configuration: Configuration) {
        self.manager = manager
        self.configuration = configuration
    }

    public var body: some View {
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
    let configuration: Configuration
    
    
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

struct CountryPickerView_Previews: PreviewProvider {
    static var previews: some View {
        CountryPickerView(configuration: Configuration())
    }
}

public
struct Configuration {
    
    public let flagStyle: CountryFlagStyle
    public let labelFont: Font
    public let labelColor: Color
    public let detailFont: Font
    public let detailColor: Color
    public let isCountryFlagHidden: Bool
    public let isCountryDialHidden: Bool
    public let navigationTitleText: String
    
    public init(
        flagStyle: CountryFlagStyle = CountryFlagStyle.corner,
        labelFont: Font = .title3,
        labelColor: Color = .black,
        detailFont: Font = .footnote,
        detailColor: Color = .gray,
        isCountryFlagHidden: Bool = false,
        isCountryDialHidden: Bool = false,
        navigationTitleText: String = "CountryPicker"
    ) {
        self.flagStyle = flagStyle
        self.labelFont = labelFont
        self.labelColor = labelColor
        self.detailFont = detailFont
        self.detailColor = detailColor
        self.isCountryFlagHidden = isCountryFlagHidden
        self.isCountryDialHidden = isCountryDialHidden
        self.navigationTitleText = navigationTitleText
    }
}
