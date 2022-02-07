//
//  CountryPickerEngine.swift
//  CountryPicker
//
//  Created by Github on 07/01/21.
//  Copyright © 2021 SuryaKant Sharma. All rights reserved.
//

import Foundation

struct CountryPickerEngine {
    let countries: [Country]
    let filterOptions: Set<CountryFilterOption>
    
    init(countries: [Country] = CountryManager.shared.countries, filterOptions: Set<CountryFilterOption> = CountryManager.shared.filters) {
        self.countries = countries
        self.filterOptions = filterOptions
    }
    
    func filterCountries(searchText: String) -> [Country] {
         countries.compactMap { (country) -> Country? in
            
            // Filter country by country name first character
            if  filterOptions.contains(.countryName),  country.countryName.capitalized.contains(searchText.capitalized) {
                return country
            }

            // Filter country by country code and utilise `CountryFilterOptions`
            if filterOptions.contains(.countryCode),
               country.countryCode.capitalized.contains(searchText.capitalized) {
                return country
            }

            // Filter country by digit country code and utilise `CountryFilterOptions`
            if filterOptions.contains(.countryDialCode),
                let digitCountryCode = country.digitCountrycode,
                digitCountryCode.contains(searchText) {
                return country
            }

            return nil
        }.removeDuplicates()
    }
}
