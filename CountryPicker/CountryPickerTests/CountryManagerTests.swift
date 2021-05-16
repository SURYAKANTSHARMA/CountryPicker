//
//  CountryPickerTests.swift
//  CountryPickerTests
//
//  Created by Mac mini on 7/6/18.
//  Copyright © 2018 SuryaKant Sharma. All rights reserved.
//

import XCTest
@testable import CountryPicker

class CountryPickerTests: XCTestCase {
    var countryManager: CountryManager!
    
    var validCountryFilePath: String? {
        let bundle = Bundle(for: CountryManager.self)
        return bundle.path(forResource: "CountryPickerController.bundle/countries", ofType: "plist")
    }
    
    var invalidCountryFilePath: String? {
        let bundle = Bundle(for: CountryManager.self)
        return bundle.path(forResource: "CountryPickerController.bundle/countriess", ofType: "plist")
    }
    
    override func setUp() {
        super.setUp()
        countryManager = CountryManager.shared
    }
    
    override func tearDown() {
        super.tearDown()
        countryManager = nil
    }
    
    func test_afterloadMethod_countriesShoulLoadCorrectly() {
        XCTAssertFalse(countryManager.countries.isEmpty)
        XCTAssert(countryManager.allCountries([]).count != 0, "Cann't load countries")
        XCTAssertEqual(countryManager.defaultFilter, .countryName)
    }
    
    func test_currentCountryCode() {
        XCTAssertEqual(countryManager.currentCountry!.countryCode, Locale.current.regionCode!)
    }
    
    func test_contriesLoadedIncorrect_order() {
        let firstCountry = countryManager.countries[0].countryName
        let secondCountry = countryManager.countries[1].countryName
        XCTAssert(firstCountry < secondCountry)
    }
    
    func test_allCountries_withFavouriteCountries_shouldReturnWIthMerge() {
        let initialCount = countryManager.countries.count
        XCTAssertEqual(initialCount, countryManager.allCountries([]).count)
        
        let newCountriesWithFavourite = countryManager.allCountries(["IN", "US"])
        
        XCTAssertEqual(newCountriesWithFavourite.count, initialCount + 2)
        
        XCTAssertEqual(newCountriesWithFavourite[0].countryName, "India")
        XCTAssertEqual(newCountriesWithFavourite[1].countryName, "United States")
    }
    
    
    func test_addFilter_shouldAbleToInsertFilter() {
        countryManager.addFilter(.countryName)
        XCTAssertTrue(countryManager.filters.contains(.countryName))
        countryManager.addFilter(.countryDialCode)
        XCTAssertTrue(countryManager.filters.contains(.countryDialCode))
        XCTAssertTrue(countryManager.filters.contains(.countryName))
    }
    
    func test_removeFilter_shouldAbleToRemoveFilter() {
        countryManager.removeFilter(.countryName)
        
        XCTAssertFalse(countryManager.filters.contains(.countryName))
    }
    
    func test_clearAllFilter_shouldAbleToRemoveAllFilter_exceptDefault() {
        countryManager.clearAllFilters()
        
        XCTAssertEqual(countryManager.filters, [.countryName])
    }
    
    func test_manager_should_able_toReturnCountry_with_AnyOfRequiredField() {
        let country = Country(countryCode: "IN")
        XCTAssertEqual(countryManager.country(withCode: "IN"), country)
        XCTAssertEqual(countryManager.country(withName: "India"), country)
        XCTAssertEqual(countryManager.country(withDigitCode: "+91"), country)
        XCTAssertNil(countryManager.country(withDigitCode: "+3232"))
    }
    
    func test_countryLoading_withValidPath() {
        let urlPath = URL(fileURLWithPath: validCountryFilePath ?? "")
        let countries = try? countryManager.fetchCountries(fromURLPath: urlPath)
        XCTAssertNotNil(countries)
        XCTAssertEqual(countries?.count, 250)
    }
    
    func test_countryLoading_withInvalidPath() {
        let urlPath = URL(fileURLWithPath: invalidCountryFilePath ?? "")
        let countries = try? countryManager.fetchCountries(fromURLPath: urlPath)
        XCTAssertNil(countries)
        XCTAssertEqual(countries?.count, nil)
    }
    
    func test_lastCountrySelected() {
        
        let countrySelected = countryManager.country(withCode: "TZ")
        countryManager.lastCountrySelected = countrySelected
        XCTAssertEqual(countryManager.lastCountrySelected?.countryCode, countrySelected?.countryCode)
    }
    
    func test_resetLastCountrySelected() {
        let countrySelected = countryManager.country(withCode: "TZ")
        countryManager.lastCountrySelected = countrySelected
        XCTAssertEqual(countryManager.lastCountrySelected?.countryCode, countrySelected?.countryCode)
        
        countryManager.resetLastSelectedCountry()
        XCTAssertNil(countryManager.lastCountrySelected)
    }
    
    func testPerformanceLoadAndSortCountries() {
        self.measure {
            do {
                try countryManager.loadCountries()
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
    }
}

