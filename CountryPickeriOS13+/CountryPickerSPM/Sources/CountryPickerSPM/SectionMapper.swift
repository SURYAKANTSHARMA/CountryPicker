//
//  SectionMapper.swift
//  
//
//  Created by Surya on 09/07/23.
//

import Foundation

struct Section: Equatable {
    let title: String
    let countries: [Country]
}

struct SectionMapper {
    
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
        return sections
    }
}
