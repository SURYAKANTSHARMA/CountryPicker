//
//  CountryManagerTests.swift
//  CountryManagerTests
//
//  Created by Mac mini on 7/6/18.
//  Copyright © 2018 SuryaKant Sharma. All rights reserved.
//

import XCTest
@testable import CountryPicker

@MainActor
class CountryManagerTests: XCTestCase {
    
    var validCountryFilePath: String? {
#if SWIFT_PACKAGE
        let bundle = Bundle.module
#else
        let bundle = Bundle(for: Country.self)
#endif
        return bundle.path(forResource: "CountryPickerController.bundle/countries", ofType: "plist")
    }
    
    var invalidCountryFilePath: String? {
        let bundle = Bundle(for: CountryManager.self)
        return bundle.path(forResource: "CountryPickerController.bundle/countriess", ofType: "plist")
    }
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_afterloadMethod_countriesShoulLoadCorrectly() {
        var countryManager: CountryManager! = makeSUT()
        defer {
            countryManager = nil
        }
        XCTAssertFalse(countryManager.countries.isEmpty)
        XCTAssert(countryManager.allCountries([]).count != 0, "Cann't load countries")
        XCTAssertEqual(countryManager.defaultFilter, .countryName)
    }
    
    func test_currentCountryCode() {
        let countryManager = makeSUT()
        XCTAssertEqual(countryManager.currentCountry!.countryCode, Locale.current.regionCode!)
    }
    
    func test_contriesLoadedIncorrect_order() {
        let countryManager = makeSUT()
        let firstCountry = countryManager.countries[0].countryName
        let secondCountry = countryManager.countries[1].countryName
        XCTAssert(firstCountry < secondCountry)
    }
    
    func test_allCountries_withFavouriteCountries_shouldReturnWIthMerge() {
        let countryManager = makeSUT()
        let initialCount = countryManager.countries.count
        XCTAssertEqual(initialCount, countryManager.allCountries([]).count)
        
        let newCountriesWithFavourite = countryManager.allCountries(["IN", "US"])
        
        XCTAssertEqual(newCountriesWithFavourite.count, initialCount + 2)
        
        XCTAssertEqual(newCountriesWithFavourite[0].countryName, "India")
        XCTAssertEqual(newCountriesWithFavourite[1].countryName, "United States")
    }
    
    
    func test_addFilter_shouldAbleToInsertFilter() {
        let countryManager = makeSUT()
        countryManager.addFilter(.countryName)
        XCTAssertTrue(countryManager.filters.contains(.countryName))
        countryManager.addFilter(.countryDialCode)
        XCTAssertTrue(countryManager.filters.contains(.countryDialCode))
        XCTAssertTrue(countryManager.filters.contains(.countryName))
    }
    
    func test_removeFilter_shouldAbleToRemoveFilter() {
        let countryManager = makeSUT()
        countryManager.removeFilter(.countryName)
        
        XCTAssertFalse(countryManager.filters.contains(.countryName))
    }
    
    func test_clearAllFilter_shouldAbleToRemoveAllFilter_exceptDefault() {
        let countryManager = makeSUT()
        countryManager.clearAllFilters()
        
        XCTAssertEqual(countryManager.filters, [.countryName])
    }
    
    func test_manager_should_able_toReturnCountry_with_AnyOfRequiredField() {
        let countryManager = makeSUT()
        let country = Country(countryCode: "IN")
        XCTAssertEqual(countryManager.country(withCode: "IN"), country)
        XCTAssertEqual(countryManager.country(withName: "India"), country)
        XCTAssertEqual(countryManager.country(withDigitCode: "+91"), country)
        XCTAssertNil(countryManager.country(withDigitCode: "+3232"))
    }
    
    func test_countryLoading_withValidPath() throws {
        let countryManager = makeSUT()
        let urlPath = URL(fileURLWithPath: validCountryFilePath ?? "")
        let countries = try countryManager.fetchCountries(fromURLPath: urlPath)
        XCTAssertNotNil(countries)
        XCTAssertEqual(countries.count, 250)
    }
    
    func test_countryLoading_withInvalidPath() {
        let countryManager = makeSUT()
        let urlPath = URL(fileURLWithPath: invalidCountryFilePath ?? "")
        XCTAssertThrowsError(try countryManager.fetchCountries(fromURLPath: urlPath)) { error in
            guard let countryManagerError = error as? CountryManagerError else {
                XCTFail("Error is not of type CountryManagerError")
                return
            }
            switch countryManagerError {
            case .missingCountriesFile(let path):
                XCTAssertEqual(path, urlPath.absoluteString)
            }
        }
    }
    
    func test_lastCountrySelected() {
        let countryManager = makeSUT()
        let countrySelected = countryManager.country(withCode: "TZ")
        countryManager.lastCountrySelected = countrySelected
        XCTAssertEqual(countryManager.lastCountrySelected?.countryCode, countrySelected?.countryCode)
    }
    
    func test_resetLastCountrySelected() {
        let countryManager = makeSUT()
        let countrySelected = countryManager.country(withCode: "TZ")
        countryManager.lastCountrySelected = countrySelected
        XCTAssertEqual(countryManager.lastCountrySelected?.countryCode, countrySelected?.countryCode)
        
        countryManager.resetLastSelectedCountry()
        XCTAssertNil(countryManager.lastCountrySelected)
    }
    
    func makeSUT() -> CountryManager {
        return CountryManager.shared
    }
    
    func testPerformanceLoadAndSortCountries() {
        self.measure {
            do {
                let countryManager = makeSUT()
                try countryManager.loadCountries()
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
    }
}

