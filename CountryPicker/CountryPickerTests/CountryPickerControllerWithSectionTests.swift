//
//  CountryPickerControllerWithSectionTests.swift
//  CountryPickerTests
//
//  Created by tokopedia on 08/01/21.
//  Copyright © 2021 SuryaKant Sharma. All rights reserved.
//

import Foundation
import XCTest
@testable import CountryPicker

class CountryPickerControllerWithSectionTests: XCTestCase {
        
    func test_presentController_shouldAbleToPresent() {
        let vc = UIViewController()
        let sut = makeSUT(presentingVC: vc)
        XCTAssertEqual(sut.presentingVC, vc)
    }
    
    
    func test_presentController_shouldAbleToSetCallback() {
       
        var logCallbackCounter = 0
        var selectedCountry: Country?
        
        let callback:(Country) -> Void = { country in
            logCallbackCounter += 1
            selectedCountry = country
        }
        let sut = makeSUT(callback: callback)
        let country = Country(countryCode: "IN")
        sut.callBack?(country)
        
        
        XCTAssertEqual(selectedCountry, country)
        XCTAssertEqual(logCallbackCounter, 1)
    }
    
    func test_table_numberOfSection_equalTo() {
        let sut = makeSUT()
        sut.applySearch = false
        
        sut.countries = [Country(countryCode: "IN"), Country(countryCode: "US"), Country(countryCode: "IDN")]
        sut.fetchSectionCountries()
        
        
        XCTAssertEqual(sut.sections, ["I", "U"])
        XCTAssertEqual(sut.sectionCoutries["I"]?.contains(Country(countryCode: "IN")), true)
        XCTAssertEqual(sut.sectionCoutries["I"]?.contains(Country(countryCode: "IDN")), true)
        XCTAssertEqual(sut.sectionCoutries["U"]?.contains(Country(countryCode: "US")), true)
        
    }
    
    func test_scrollToCountryShould_scrollTableViewToContryIndexPath() {
        let sut = makeSUT()
        sut.applySearch = false
        sut.loadCountries()
        let country = Country(countryCode: "IN")
        let row = sut.sectionCoutries["I"]?.firstIndex(where: { $0.countryCode == country.countryCode}) ?? 0
        let section =  sut.sectionCoutries.keys.map { $0 }.sorted().firstIndex(of: "I") ?? 0
        
        sut.scrollToCountry(Country(countryCode: "IN"), withSection: country.countryName.first!, animated: false)
        
        
        XCTAssertTrue(sut.tableView.indexPathsForVisibleRows?.contains(IndexPath(row: row, section: section)) ?? false )
        
    }
    
    func test_scrollToCountryShould_whenApplySearchShouldNotScroll() {
        let sut = makeSUT()
        sut.applySearch = true
        sut.loadCountries()
        let country = Country(countryCode: "IN")
        let row = sut.sectionCoutries["I"]?.firstIndex(where: { $0.countryCode == country.countryCode}) ?? 0
        let section =  sut.sectionCoutries.keys.map { $0 }.sorted().firstIndex(of: "I") ?? 0
        
        sut.scrollToCountry(Country(countryCode: "IN"), withSection: country.countryName.first!, animated: false)
        
        
        XCTAssertFalse(sut.tableView.indexPathsForVisibleRows?.contains(IndexPath(row: row, section: section)) ?? false )
        
    }
    
    func test_numberOfSection_withOutApplySearch_withOutFavorite() {
        let sut = makeSUT()
        sut.applySearch = false
        let sectionCount = sut.tableView.dataSource?.numberOfSections?(in: sut.tableView)
        
        XCTAssertEqual(sectionCount, sut.sections.count)
    }
    
    func test_numberOfSection_withApplySearch_shouldAlwaysRetrunOneSection() {
        let sut = makeSUT()
        sut.applySearch = true
        
        let sectionCount = sut.tableView.dataSource?.numberOfSections?(in: sut.tableView)
        sut.applySearch = true
        XCTAssertEqual(sectionCount, 1)
        sut.favoriteCountriesLocaleIdentifiers = ["IN"]
        XCTAssertEqual(sectionCount, 1)
    }
    
    func test_numberOfRowsInSection_withAppliedSeach_shouldShowOnlyFilterCountryCount() {
        let sut = makeSUT()
        sut.applySearch = true
       
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), sut.filterCountries.count)
        
        sut.favoriteCountriesLocaleIdentifiers = ["IN"]
        XCTAssertEqual(sut.tableView.dataSource?.tableView(sut.tableView, numberOfRowsInSection: 0), sut.filterCountries.count)
    }
    
    func test_numberOfRowsInSection_withoutAppliedSeach_shouldShowCountryOnSection() {
        let sut = makeSUT()
        sut.applySearch = false
        
        let section = 0
        let rowsCount = sut.tableView.dataSource?.tableView(sut.tableView, numberOfRowsInSection: section)
        XCTAssertEqual(rowsCount, sut.firstSectionCount)
    }
    
    func test_numberOfRowsInSection_withoutAppliedSeach_withFavourites() {
        let sut = makeSUT()
        sut.applySearch = false
        let favouriteIdetifiers = ["IN", "US"]
        sut.favoriteCountriesLocaleIdentifiers = favouriteIdetifiers
        
        
        XCTAssertEqual(sut.tableView.dataSource?.tableView(sut.tableView, numberOfRowsInSection: 0), favouriteIdetifiers.count)
        
        XCTAssertEqual(sut.tableView.dataSource?.tableView(sut.tableView, numberOfRowsInSection: 1), sut.firstSectionCount)
    }
    
    func test_titleForHeaderInSectionInRow_withAppliedSearch_shouldReturnSearchTitle() {
        let sut = makeSUT()
        let tableView = sut.tableView
        sut.applySearch = true
    
        XCTAssertEqual(tableView.dataSource?.tableView?(tableView, titleForHeaderInSection: 0), "A")
    }
    
    func test_titleForHeaderInSectionInRow_withoutAppliedSearch_shouldReturnSearchTitle() {
        let sut = makeSUT()
        let tableView = sut.tableView
        sut.applySearch = false
        
        XCTAssertEqual(tableView.dataSource?.tableView?(tableView, titleForHeaderInSection: 0), "A")
        
        sut.favoriteCountriesLocaleIdentifiers = ["IN"]
        XCTAssertNil(tableView.dataSource?.tableView?(tableView, titleForHeaderInSection: 0))
    }
    
    func test_cellConfiguration_ofTableView_withoutAppliedSearch() {
        let sut = makeSUT()
        let tableView = sut.tableView
        sut.applySearch = false
        
        let cell = tableView.dataSource?.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? CountryCell
        XCTAssertEqual(cell?.country, Country(countryCode: "AF"))
    }
    
    //MARK: - Helpers
    func makeSUT(presentingVC: UIViewController = UIViewController(), callback:((Country) -> Void)? = nil) -> CountryPickerWithSectionViewController {
        let sut = CountryPickerWithSectionViewController.presentController(on: presentingVC) { country in
            callback?(country)
        }
        sut.startLifeCycle()
        return sut
    }
    
   
    
}

private extension CountryPickerWithSectionViewController {
    var firstSectionCount: Int {
        sectionCoutries["A"]!.count
    }
}
