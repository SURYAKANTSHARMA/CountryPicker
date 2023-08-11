//
//  CountryTest.swift
//  CountryPickerTests
//
//  Created by Github on 03/01/21.
//  Copyright © 2021 SuryaKant Sharma. All rights reserved.
//

import Foundation
import XCTest
@testable import CountryPicker

class CountryTests: XCTestCase {
    
    func test_afterInit() {
        let sut = Country(countryCode: "IN")
        
        XCTAssertEqual(sut.countryCode, "IN")
        XCTAssertEqual(sut.countryName, "India")
        XCTAssertEqual(sut.dialingCode, "+91")
        XCTAssertEqual(sut.digitCountrycode, "91")
        XCTAssertNotNil(sut.flag)
        XCTAssertEqual(sut.imagePath, "CountryPickerController.bundle/IN")
    }
    
    func test_CountryNameWithLocal_returnRightCountryName() {
        let sut = Country(countryCode: "IN")
        let local = Locale(identifier: "en")
        
        let countryName = sut.countryName(with: local)
        
        XCTAssertEqual(countryName, "India")
        
        let nepalIndianLocal = Locale(identifier: "ne_IN")
        XCTAssertEqual(sut.countryName(with: nepalIndianLocal), "भारत")
    }
    
    func test_CountryNameWithLocalIdentifier_returnRightCountryName() {
        let sut = Country(countryCode: "IN")
        let localIdentifier = "en"
        
        let countryName = sut.countryName(withLocaleIdentifier: localIdentifier)
        
        XCTAssertEqual(countryName, "India")
        
        let nepalIndianLocal = "ne_IN"
        XCTAssertEqual(sut.countryName(withLocaleIdentifier: nepalIndianLocal), "भारत")
    }
    
    func test_mapCountryCode_returnRightCountryName() {
        XCTAssertEqual(mapCountryName("US"), "United States")
    }
    
    func test_equalCountries() {
        XCTAssertEqual(Country(countryCode: "IN"), Country(countryCode: "IN"))
        XCTAssertNotEqual(Country(countryCode: "IN"), Country(countryCode: "US"))
    }
}
