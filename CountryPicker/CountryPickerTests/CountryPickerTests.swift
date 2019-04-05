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

    var country: Country!
    var countryManager: CountryManager!
    var totalCountries = 249
    override func setUp() {
        super.setUp()
        country = Country(countryCode: "IN")
        countryManager = CountryManager.shared
    }

    override func tearDown() {
        super.tearDown()
        country = nil
        countryManager = nil
    }

    func testCountry() {
        XCTAssert(country.countryName.capitalized == "India", "Countryname is faulty")
        XCTAssert(country.dialingCode! ==  "+91", "Dialing Code is faulty")
        XCTAssertNotNil(country.flag)
    }

    func testCountryManager() {
        XCTAssert(countryManager.currentCountry!.countryCode == ((Locale.current as NSLocale).object(forKey: .countryCode) as! String), "faulty default country")
        XCTAssert(countryManager.countries.count == totalCountries, "Fault in loading countries")
        XCTAssert(countryManager.countries[0].countryName < countryManager.countries[1].countryName, "Faulty in sorting")
    }

    func testPerformanceLoadAndSortCountries() {
        self.measure {
            do {
                try countryManager.loadCountries()
            } catch {
                print(error.localizedDescription)
            }

        }
    }

}
