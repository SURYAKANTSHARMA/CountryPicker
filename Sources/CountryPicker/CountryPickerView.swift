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
    
    @Environment(\.presentationMode) var presentationMode

    @State private var filterCountries = [Country]()
    @State private var applySearch = false
    @State private var searchText = ""
    @Binding private var selectedCountry: Country?
    
    let configuration: Configuration
    let manager: any CountryListDataSource

    private var searchResults: [Country] {
        searchText.isEmpty ? manager.allCountries([]) : filterCountries
    }

    public
    init(manager: any CountryListDataSource = CountryManager.shared,
         configuration: Configuration = Configuration(),
         selectedCountry: Binding<Country?>) {
        self.manager = manager
        self.configuration = configuration
        self._selectedCountry = selectedCountry
    }

    public var body: some View {
        NavigationView {
            List(searchResults) { country in
                CountryCell(country: country,
                            isSelected: selectedCountry == country,
                            configuration: configuration,
                            selectedCountry: $selectedCountry)
            }
            .listStyle(.grouped)
            .searchable(text: $searchText)
            .accessibilityLabel("Country list")
            .accessibilityHint("List of countries to choose from")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.callout)
                            .accessibilityLabel("Close")
                            .accessibilityHint("Dismiss country picker")
                    }
                }
            }
            .navigationTitle(configuration.navigationTitleText)
            .onChange(of: searchText) { _ in
                filterCountries = manager.filterCountries(searchText: searchText)
                if configuration.accessibilityConfiguration?.enableVoiceOverAnnouncements == true {
                    let announcement = searchText.isEmpty ? 
                        "Showing all countries" : 
                        "Found \(filterCountries.count) countries matching '\(searchText)'"
                    UIAccessibility.post(notification: .announcement, argument: announcement)
                }
            }
            .onDisappear {
                manager.lastCountrySelected = selectedCountry
            }
        }
        .onChange(of: selectedCountry) { newCountry in
            guard let country = newCountry else { return }
            if configuration.accessibilityConfiguration?.enableVoiceOverAnnouncements == true {
                let announcement = "Selected \(country.countryName)"
                UIAccessibility.post(notification: .announcement, argument: announcement)
            }
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct CountryCell: View {
    
    let country: Country
    let isSelected: Bool
    let configuration: Configuration
    
    @Binding var selectedCountry: Country?
    
    var body: some View {
        Button {
            selectedCountry = country
        } label: {
            HStack {
                let image = Image(uiImage: country.flag ?? .init())
                    .resizable()

                if !configuration.isCountryFlagHidden {
                    switch configuration.flagStyle {
                    case .normal:
                           image
                            .frame(width: 40, height: 26)
                            .scaledToFit()
                    case .circular:
                        image
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())

                    case .corner:
                        image.frame(width: 40, height: 26)
                            .scaledToFit()
                            .cornerRadius(8)
                    }
                }
                VStack(alignment: .leading) {
                    Text(country.countryName)
                        .font(configuration.labelFont)
                        .foregroundColor(configuration.labelColor)
                        .accessibilityLabel(country.countryName)

                    if !configuration.isCountryDialHidden {
                        Text(country.dialingCode ?? "")
                            .font(configuration.detailFont)
                            .foregroundColor(configuration.detailColor)
                    }
                }

                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .accessibilityLabel("Selected")
                        .accessibilityAddTraits(.isSelected)
                }
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(country.countryName) \(isSelected ? ", selected" : "")")
    }
}

struct CountryPickerView_Previews: PreviewProvider {
    static var previews: some View {
        CountryPickerView(
            configuration: Configuration(),
            selectedCountry: .constant(Country(countryCode: "IN")))
    }
}


