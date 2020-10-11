//
//  TestCountryPickerFrameworkUITests.swift
//  TestCountryPickerFrameworkUITests
//
//  Created by Suryakant Sharma-Pro on 27/04/19.
//  Copyright © 2019 SuryaKant Sharma. All rights reserved.
//

import XCTest

class TestCountryPickerFrameworkUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testOpenAndSelectCountry() {
        let app = XCUIApplication()
        let selectionButton = app.buttons["Select country picker"]
        selectionButton.tap()
        let searchBar = app.searchFields["Search country name here.."]
        searchBar.doubleTap()
        searchBar.typeText("ind")
        let cell = app.tables.cells["India"]
        cell.tap()
        XCTAssertFalse(cell.exists,"Cell doesn't load")
        
        XCTAssertTrue(app.buttons["Select country picker"].exists)
        //sleep(1)
        XCTAssert((app.buttons["Select country picker"].value as! String) != nil)
    }
    
    
    
    func testDismiss() {
        let app = XCUIApplication()
        let selectionButton = app.buttons["Select country picker"]
        selectionButton.tap()
        let crossbutton = app.navigationBars["SKCountryPicker.CountryPickerWithSectionView"].buttons["cross"]
        crossbutton.tap()
        XCTAssertFalse(crossbutton.exists,"Cell doesn't load")
    }

}
