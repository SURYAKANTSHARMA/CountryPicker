//
//  CountryPickerViewTests.swift
//  CountryPickerTests
//
//  Created by tokopedia on 03/01/21.
//  Copyright © 2021 SuryaKant Sharma. All rights reserved.
//

import Foundation
import XCTest
@testable import CountryPicker

class CountryPickerViewTests: XCTestCase {
    
    func init_shouldLoadView_with_givenCountries() {
        let countries = [Country(countryCode: "IN"), Country(countryCode: "US")]
        let sut = CountryPickerView(allCountryList: countries)
        let numberOfComponent = sut.dataSource?.numberOfComponents(in: sut)
        XCTAssertEqual(numberOfComponent, 1)
        let numberOfRows = sut.dataSource?.pickerView(sut, numberOfRowsInComponent: 0)
        XCTAssertEqual(numberOfRows, countries.count)
        // Should be default selected for index 0
        XCTAssertEqual(sut.selectedRow(inComponent: 1), 0)

    }
    
}


