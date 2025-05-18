//
//  SectionMapper.swift
//  
//
//  Created by Surya on 09/07/23.
//

import Foundation

struct Section: Equatable, Identifiable {
    let title: String?
    var countries: [Country]
    
    var id: String {
        title ?? ""
    }
}

struct SectionMapper {
    
    let favoriteCountriesLocaleIdentifiers: [String]
    
    func mapIntoSection(countries: [Country]) -> [Section] {
                
        let titles = countries
            .map { String($0.countryName.prefix(1)).first! }
            .map { String($0) }
            .removeDuplicates()
            .sorted(by: <)
        
        
        let sections = titles
            .map { title in
                let countries = countries.filter { country in
                    String(country.countryName.prefix(1)) == title
                }
                let section = Section(title: title,
                                      countries: countries)
                return section
            }
        
        guard !favoriteCountriesLocaleIdentifiers.isEmpty else {
            return sections
        }
        let favouriteSection = favoriteCountriesLocaleIdentifiers
            .map { Country(countryCode: $0) }
            .reduce(Section(title: nil,
                            countries: []),
                    { partialResult, country in
                return Section(title: partialResult.title,
                               countries: partialResult.countries + [country])
            })
        return [favouriteSection] + sections
    }
}
