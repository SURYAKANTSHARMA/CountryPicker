//
//  SectionMapperTests.swift
//  
//
//  Created by Surya on 09/07/23.
//

import XCTest
@testable import CountryPickerSPM

final class SectionMapperTests: XCTestCase {
    
    func test_sectionmapperWhenInitWithEmptyCountries_shouldAbleToReturnEmptySectionWithGivenCountriesInAlphabeticOrder() {
        let sut = SectionMapper(favoriteCountriesLocaleIdentifiers: [])
        
        XCTAssertEqual(sut.mapIntoSection(countries: [
        ]), [])
    }
    
    
    func test_sectionmapperWhenInitWithCountries_shouldAbleToReturnSectionWithGivenCountriesInAlphabeticOrder() {
        let sut = SectionMapper(favoriteCountriesLocaleIdentifiers: [])

        let expectationOutput = [
            Section(title: "A", countries: [
                Country(countryCode: "AF"),
            ]),
            Section(title: "I", countries: [
                Country(countryCode: "IN"),
                Country(countryCode: "IS")
            ]),
            
            Section(title: "U", countries: [
                Country(countryCode: "US")
            ])
        ]

        XCTAssertEqual(sut.mapIntoSection(countries: [
            Country(countryCode: "IN"),
            Country(countryCode: "IS"),
            Country(countryCode: "AF"),
            Country(countryCode: "US")
        ]), expectationOutput)
    }
    
    
    func test_withFavouriteCountries_sectionShouldReturnFirstCountryWithFavouriteSectionWithNilTitle() {
        // Given
        let countries = [
            Country(countryCode: "IN"),
            Country(countryCode: "AF"),
            Country(countryCode: "US"),
            Country(countryCode: "IS")
        ]
        
        let favoriteCountriesLocaleIdentifiers = ["IN"]
        let sut = SectionMapper(favoriteCountriesLocaleIdentifiers: favoriteCountriesLocaleIdentifiers)
        
        let expectationOutput = [
            Section(title: nil,
                    countries: [
                        Country(countryCode: "IN")
                    ]),
            Section(title: "A", countries: [
                Country(countryCode: "AF"),
            ]),
            Section(title: "I", countries: [
                Country(countryCode: "IN"),
                Country(countryCode: "IS")
            ]),
            
            Section(title: "U", countries: [
                Country(countryCode: "US")
            ])
        ]

        
        // when
        let result = sut.mapIntoSection(countries: countries)
        
        // then 
        XCTAssertEqual(result, expectationOutput)
        
    }
}
