//
//  CountryPickerEngineTests.swift
//  CountryPickerTests
//
//  Created by Github on 07/01/21.
//  Copyright © 2021 SuryaKant Sharma. All rights reserved.
//

import XCTest
@testable import CountryPicker

class CountryPickerEngineTests: XCTestCase {
    
    func test_filterCountries_shouldFilterCountryNameCorrectCountries() {
        let countries = [Country(countryCode: "IN"), Country(countryCode: "US")]
        let sut = CountryPickerEngine(countries: countries, filterOptions: [.countryName])
        
        let filters = sut.filterCountries(searchText: "ind")
        
        XCTAssertEqual(filters, [countries[0]])
    }
    
    func test_filterCountries_shouldFilterCountryCodesCorrectCountries() {
        let countries = [Country(countryCode: "IN"), Country(countryCode: "US")]
        let sut = CountryPickerEngine(countries: countries, filterOptions: [.countryCode])
        
        let filters = sut.filterCountries(searchText: "U")
        XCTAssertEqual(filters, [countries[1]])
        
        let filtersWithI = sut.filterCountries(searchText: "I")
        XCTAssertEqual(filtersWithI, [countries[0]])
        
        let filtersWithD = sut.filterCountries(searchText: "D")
        XCTAssertEqual(filtersWithD, [])
    }
    
    
    func test_filterCountries_shouldFilterDialingCodesCorrectCountries() {
        let countries = [Country(countryCode: "IN"), Country(countryCode: "US")]
        let sut = CountryPickerEngine(countries: countries, filterOptions: [.countryDialCode])
        
        let filters = sut.filterCountries(searchText: "IN")
        
        XCTAssertEqual(filters, [])
        
        let dialingfilters = sut.filterCountries(searchText: "1")
        
        XCTAssertEqual(dialingfilters.first?.countryCode, "IN")
        XCTAssertEqual(dialingfilters[1].countryCode, "US")
        
        
        let dialingfiltersOnly9 = sut.filterCountries(searchText: "9")
        
        XCTAssertEqual(dialingfiltersOnly9, [countries[0]])
    }
    
    
    func test_filterCountries_shouldFilterCorrectCountries() {
        let countries = [Country(countryCode: "IN"), Country(countryCode: "US")]
        let sut = CountryPickerEngine(countries: countries, filterOptions: [.countryCode, .countryName])
        
        let filters = sut.filterCountries(searchText: "us")
        
        XCTAssertTrue(filters.contains(Country(countryCode: "US")))
    }
}
