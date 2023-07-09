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
        let sut = SectionMapper(countries: [
        ])
        
        XCTAssertEqual(sut.mapIntoSection(), [])
    }
    
    
    func test_sectionmapperWhenInitWithCountries_shouldAbleToReturnSectionWithGivenCountriesInAlphabeticOrder() {
        let sut = SectionMapper(countries: [
            Country(countryCode: "IN"),
            Country(countryCode: "IS"),
            Country(countryCode: "AF"),
            Country(countryCode: "US")
        ])

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

        XCTAssertEqual(sut.mapIntoSection(), expectationOutput)
    }
}
