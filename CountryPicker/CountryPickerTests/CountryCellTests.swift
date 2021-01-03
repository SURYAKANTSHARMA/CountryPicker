//
//  CountryCellTests.swift
//  CountryPickerTests
//
//  Created by tokopedia on 03/01/21.
//  Copyright © 2021 SuryaKant Sharma. All rights reserved.
//

import XCTest
@testable import CountryPicker

class CountryCellTests: XCTestCase {
    
    func test_cellDisplay_correct_country() {
        let country = Country(countryCode: "IN")
        let sut = CountryCell()
        XCTAssertNil(sut.country)
        sut.country = country
        
        XCTAssertEqual(sut.nameLabel.text, "India")
        XCTAssertEqual(sut.diallingCodeLabel.text, "+91")
        XCTAssertNotNil(sut.flagImageView)
        XCTAssertEqual(sut.flagStyle, .normal)
    }
}
