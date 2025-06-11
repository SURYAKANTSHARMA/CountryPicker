//
//  CountryPickerWithSectionViewModel.swift
//  
//
//  Created by Surya on 09/07/23.
//

import Combine

public final
class CountryPickerWithSectionViewModel: ObservableObject {
        
    @Published var sections: [Section] = []
    @Published var selectedCountry: Country
    
    private let dataService: any CountryListDataSource
    private let mapper: SectionMapper
    
    internal init(dataService: any CountryListDataSource = CountryManager.shared,
                  mapper: SectionMapper = SectionMapper(favoriteCountriesLocaleIdentifiers: []),
                  selectedCountry: Country
    ) {
        self.dataService = dataService
        self.mapper = mapper
        self.selectedCountry = selectedCountry
        sections = mapper.mapIntoSection(countries: dataService.allCountries(mapper.favoriteCountriesLocaleIdentifiers))
    }
    
    func filterWithText(_ text: String) {        
        let filteredCountries = text.isEmpty ? dataService.allCountries(mapper.favoriteCountriesLocaleIdentifiers) :  dataService.filterCountries(searchText: text)
        sections = mapper.mapIntoSection(countries: filteredCountries)
    }
    
    func setLastSelectedCountry() {
        dataService.lastCountrySelected = selectedCountry
    }
    
    func reset() {
        filterWithText("")
    }
}

