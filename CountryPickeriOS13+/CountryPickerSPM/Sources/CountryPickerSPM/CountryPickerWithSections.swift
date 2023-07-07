//
//  SwiftUIView.swift
//  
//
//  Created by Surya on 27/05/23.
//

import SwiftUI
public
struct CountryPickerWithSections: View {
    let manager: any CountryListDataSource
    @State private var filterCountries = [Country]()
    @State private var applySearch = false
    @State private var searchText = ""
    @State private var selectedCountry: Country?
    let configuration: Configuration
    private var isFilterApplied: Bool {
        return !searchText.isEmpty
    }
    private var searchResults: [Country] {
        isFilterApplied ? manager.allCountries([]) : filterCountries
    }

    public init(manager: any CountryListDataSource = CountryManager.shared,
         configuration: Configuration) {
        self.manager = manager
        self.configuration = configuration
    }

    public var body: some View {
        NavigationView {
            ScrollViewReader { scrollView in
                List {
                    ForEach(getDataSource().sectionTitles, id: \.self) { section in
                        
                        let countriesAtSection = getDataSource().countries[0]
                            .filter { $0.countryName.hasPrefix(section) }
//                        if !countriesAtSection.isEmpty {
                            Section(header: Text(section)) {
                                ForEach(countriesAtSection) { country in
                                    CountryCell(country: country,
                                                isFavorite: selectedCountry == country,
                                                selectedCountry: $selectedCountry,
                                                configuration: configuration)
                                        .onTapGesture {
                                            selectedCountry = country
                                        }
                                }
                            }
//                        }
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
                .onAppear {
                    // Scroll to the selected country when appearing
                    if let selectedCountry = selectedCountry {
                        withAnimation {
                            scrollView.scrollTo(selectedCountry.countryName, anchor: .top)
                        }
                    }
                }
                .listStyle(GroupedListStyle())
            }
        }
    }
    
    private func getDataSource() -> (sectionTitles: [String],
                                     countries: [[Country]]) {
        var sections: [String] = []
        var sectionOrderedCountries =  [[Country]]()
        
        if isFilterApplied {
            sections.append("")
        }
        
        sections = searchResults
            .map { String($0.countryName.prefix(1)).first! }
            .map { String($0) }
            .removeDuplicates()
            .sorted(by: <)
        
        for (index, section) in sections.enumerated() {
            let sectionCountries = searchResults.filter {
                String($0.countryName.first!) == section
            }
            sectionOrderedCountries[index] = sectionCountries.removeDuplicates()
        }
        print(sections)
        print(sectionOrderedCountries)
        return (sections, sectionOrderedCountries)
    }
}


struct CountryPickerWithSections_Previews: PreviewProvider {
    static var previews: some View {
        CountryPickerWithSections(configuration: Configuration())
    }
}
