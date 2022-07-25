//
//  CountryCellTests.swift
//  CountryPickerTests
//
//  Created by Github on 03/01/21.
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
        
        
        sut.country = Country(countryCode: "US")
        
        XCTAssertEqual(sut.nameLabel.text, "United States")
        XCTAssertEqual(sut.diallingCodeLabel.text, "+1")
        XCTAssertNotNil(sut.flagImageView)
        XCTAssertEqual(sut.flagStyle, .normal)
    }
    
    func test_cellDisplay_withSubviews() {
        let sut = CountryCell()
       
        sut.startLifeCycle()
        
        XCTAssertNotNil(sut.checkMarkImageView.superview)
        XCTAssertNotNil(sut.flagImageView.superview)
        XCTAssertNotNil(sut.nameLabel.superview)
        XCTAssertNotNil(sut.diallingCodeLabel.superview)
        XCTAssertNotNil(sut.separatorLineView.superview)
        
    }
    
    func test_cellDisplay_withApplyFlagStyleCircular() {
        let sut = CountryCell()
       
        sut.startLifeCycle()
        sut.applyFlagStyle(.circular)
        
        sut.layoutIfNeeded()
        XCTAssertTrue(sut.flagImageView.clipsToBounds)
        
        XCTAssertEqual(sut.flagImageView.frame.width, sut.flagImageView.frame.height)
    }
    
    func test_cellDisplay_withApplyFlagStyleCorner() {
        let sut = CountryCell()
       
        sut.startLifeCycle()
        sut.applyFlagStyle(.corner)
        
        XCTAssertEqual(sut.flagImageView.layer.cornerRadius, 4)
    }
    
    func test_cellDisplay_withApplyFlagStyleNormal() {
        let sut = CountryCell()
       
        sut.startLifeCycle()
        sut.applyFlagStyle(.normal)
        
        XCTAssertEqual(sut.flagImageView.layer.cornerRadius, 0)
        XCTAssertEqual(sut.flagImageView.contentMode, .scaleToFill)
    }
    
    func test_hideDailCode_shouldHideDiallingCodeLabel() {
        let sut = CountryCell()
        sut.startLifeCycle()
        
        sut.hideDialCode(true)
        XCTAssertEqual(sut.diallingCodeLabel.isHidden, true)
    }
    
    func test_hideFlag_shouldHideFlagImageView() {
        let sut = CountryCell()
        sut.startLifeCycle()
        sut.hideFlag(true)
        
        XCTAssertTrue(sut.countryFlagStackView.isHidden)
        sut.hideFlag(false)
        XCTAssertFalse(sut.countryFlagStackView.isHidden)
    }
}

extension UIView {
    func startLifeCycle() {
        setNeedsLayout()
        layoutIfNeeded()
    }
}
