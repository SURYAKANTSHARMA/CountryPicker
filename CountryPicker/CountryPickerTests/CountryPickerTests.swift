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
    // Create SUT objects
    var country: Country!
    var countryManager: CountryManager!
    var totalCountries = 250
    override func setUp() {
        super.setUp()
        // 1. Given 2. Then
        country = Country(countryCode: "IN")
        countryManager = CountryManager.shared
    }
    
    override func tearDown() {
        super.tearDown()
        country = nil
        countryManager = nil
    }
    
    func testCountryProperties() {
        //  3. Then
        XCTAssert(country.countryName == "India", "Countryname is faulty")
        XCTAssert(country.dialingCode! ==  "+91", "Dialing Code is faulty")
        XCTAssertEqual(country.countryCode, "IN", "CountryCode is faulty")
        let path = "CountryPickerController.bundle/IN"
        let bundle = Bundle(for: Country.self)
        let image = UIImage(named: path, in: bundle, compatibleWith: nil)
        XCTAssertNotNil(image, "Image is absent in the bundle")
        XCTAssertNotNil(country.flag, "country \(country.countryCode) image is absent in the bundle")
        XCTAssertEqual(image!, country.flag!, "images are not equal")
        
        // check negitive edge case
        country.countryCode.append("s")
        XCTAssertNil(country.dialingCode)
    }
    
    func testCountryNameInLocale() {
        let identifier = "ne_IN"
        let countryNameInNepaliIndia = country.countryName(withLocaleIdentifier: identifier)
        XCTAssertEqual(countryNameInNepaliIndia, "भारत", "country name in phone locale with \(identifier) is faulty")
        let locale = Locale(identifier: "ne_IN") as NSLocale
        let countryNameInLocale = country.countryName(with: locale)
        XCTAssertEqual(countryNameInLocale, "भारत", "Country name in phone locale \(locale) is faulty")
        
    }
    
    func testCountryManager() {
        let currentCountryCode = ((Locale.current as NSLocale).object(forKey: .countryCode) as! String)
        XCTAssert(countryManager.currentCountry!.countryCode == currentCountryCode, "faulty default country")
        XCTAssert(countryManager.countries.count == totalCountries, "Fault in loading countries")
        XCTAssert(countryManager.countries[0].countryName < countryManager.countries[1].countryName, "Faulty in sorting")
        XCTAssert(countryManager.allCountries().count != 0, "Cann't load countries")
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

