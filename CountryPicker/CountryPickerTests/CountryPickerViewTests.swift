//
//  CountryPickerViewTests.swift
//  CountryPickerTests
//
//  Created by Github on 03/01/21.
//  Copyright © 2021 SuryaKant Sharma. All rights reserved.
//

import Foundation
import XCTest
@testable import CountryPicker

class CountryPickerViewTests: XCTestCase {
    
    let countries = [Country(countryCode: "IN"), Country(countryCode: "US")]
    
    func test_init_shouldLoadView_with_givenCountries() {
        let sut = makeSUT()
        let numberOfComponent = sut.dataSource?.numberOfComponents(in: sut)
        XCTAssertEqual(numberOfComponent, 1)
        let numberOfRows = sut.dataSource?.pickerView(sut, numberOfRowsInComponent: 0)
        XCTAssertEqual(numberOfRows, countries.count)
        // Should be default selected for index 0
        XCTAssertEqual(sut.selectedRow(inComponent: 0), 0)
    }
    
    func test_shouldAbletoCall_Callback_when_userSelectCountry() {
        let countries = [Country(countryCode: "IN"), Country(countryCode: "US")]
        var logCallbackCounter = 0
        var selectedCountry: Country?
        let sut = CountryPickerView.loadPickerView(allCountryList: countries) { country in
            logCallbackCounter += 1
            selectedCountry = country
        }
        
        sut.pickerView(sut, didSelectRow: 0, inComponent: 0)
        
        XCTAssertEqual(selectedCountry, countries[0])
        XCTAssertEqual(logCallbackCounter, 1)
    }
    
    func test_shouldAbletoCallCallback_whenCallbackSetExplictly() {
        let countries = [Country(countryCode: "IN"), Country(countryCode: "US")]
        var logCallbackCounter = 0
        var selectedCountry: Country?
        let sut = CountryPickerView(allCountryList: countries)
        sut.onSelectCountry { country in
            logCallbackCounter += 1
            selectedCountry = country
        }
        sut.pickerView(sut, didSelectRow: 0, inComponent: 0)
        
        XCTAssertEqual(selectedCountry, countries[0])
        XCTAssertEqual(logCallbackCounter, 1)
    }
    
    
    func test_pickerView_dataSource() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.dataSource?.numberOfComponents(in: sut), 1)
        XCTAssertEqual(sut.dataSource?.pickerView(sut, numberOfRowsInComponent: 0), countries.count)
    }
    
    
    func test_pickerView_shouldScrollToSelectedCountry() {
        XCTAssertEqual(makeSUT(selectedCountry: countries[1]).selectedRow(inComponent: 0), 1)
    }
    
    func test_pickerView_shouldReturnCorrectReusableViewForEachComponent() {
        let sut = makeSUT()
        let view = sut.pickerView(sut, viewForRow: 1, forComponent: 0, reusing: nil) as? ComponentView
        
        XCTAssertNotNil(view)
        XCTAssertNotNil(view?.imageView.image)
        XCTAssertEqual(view?.countryNameLabel.text, "United States")
        XCTAssertEqual(view?.diallingCodeLabel.text, "+1")
    }
    
    func test_pickerView_shouldReturnRowHeight() {
        let sut = makeSUT()
        let height = sut.pickerView(sut, rowHeightForComponent: 1)
        
        XCTAssertEqual(height, 45.0)
    }
    
    func test_setPickListCountryCodes_shouldAbleToUpdateCountries() {
        let sut = makeSUT()
        XCTAssertEqual(sut.dataSource?.pickerView(sut, numberOfRowsInComponent: 0), 2)
        sut.setPickList(codes: "IN")
        XCTAssertEqual(sut.pickList.count , 1)
        
        let numberOfRows = sut.dataSource?.pickerView(sut, numberOfRowsInComponent: 0)
        XCTAssertEqual(numberOfRows, 1)
    }
    
    func test_setSelectedCountry() {
        let sut = makeSUT()
        let selectedCountry = Country(countryCode: "US")
        sut.setSelectedCountry(selectedCountry)
        let selectedRowInUI = sut.selectedRow(inComponent: 0)
        let selectedCountryInUI = countries[selectedRowInUI]
        
        XCTAssertEqual(selectedCountryInUI.countryName, selectedCountry.countryName)
        XCTAssertEqual(selectedCountryInUI.countryCode, selectedCountry.countryCode)
    }
    
    func test_scrollToSelectCountry_shouldNotScroll_ifSelectedCountryIsNil() {
        let sut = CountryPickerView(allCountryList: countries, selectedCountry: nil)
        
        XCTAssertEqual(sut.selectedRow(inComponent: 0), 0)
        
    }
    
    // MARK :- Helpers
    func makeSUT(selectedCountry: Country? = nil ) -> CountryPickerView {
        let sut = CountryPickerView(allCountryList: countries, selectedCountry: selectedCountry)
        return sut
    }
}


