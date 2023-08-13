//
//  CountryPickerWithSectionViewModel.swift
//  
//
//  Created by Surya on 09/07/23.
//

import Combine

public final
class CountryPickerWithSectionViewModel: ObservableObject {
    
    public static let `default` = CountryPickerWithSectionViewModel(
        dataService: CountryManager.shared,
        mapper: SectionMapper(favoriteCountriesLocaleIdentifiers: []))
    
    @Published var sections: [Section] = []
    @Published var selectedCountry: Country?
    
    private let dataService: any CountryListDataSource
    private let mapper: SectionMapper
    
    internal init(dataService: any CountryListDataSource = CountryManager.shared,
                  mapper: SectionMapper = SectionMapper(favoriteCountriesLocaleIdentifiers: []),
                  lastCountry: Country? = CountryManager.shared.lastCountrySelected ??
                  CountryManager.shared.currentCountry
    ) {
        self.dataService = dataService
        self.mapper = mapper
        self.selectedCountry = lastCountry
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

