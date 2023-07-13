//
//  CountryPickerWithSectionViewModel.swift
//  
//
//  Created by Surya on 09/07/23.
//

import Combine

class CountryPickerWithSectionViewModel: ObservableObject {
    
    @Published var sections: [Section] = []
    private let dataService: any CountryListDataSource
    private let mapper: SectionMapper
    
    internal init(dataService: any CountryListDataSource,
                  favoriteCountriesLocaleIdentifiers: [String],
                  mapper: SectionMapper
    ) {
        self.dataService = dataService
        self.mapper = mapper
        defer {
            sections = mapper.mapIntoSection(countries: dataService.allCountries(favoriteCountriesLocaleIdentifiers))
        }
    }
    
    func filterWithText(_ text: String) {
        let filteredCountries = dataService.filterCountries(searchText: text)
        sections = mapper.mapIntoSection(countries: filteredCountries)
    }
}

