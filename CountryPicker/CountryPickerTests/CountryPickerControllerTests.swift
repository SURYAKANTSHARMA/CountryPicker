//
//  CountryPickerControllerTests.swift
//  CountryPickerTests
//
//  Created by tokopedia on 07/01/21.
//  Copyright © 2021 SuryaKant Sharma. All rights reserved.
//

import Foundation
import XCTest

@testable import CountryPicker

class countryPickerControllerTests: XCTestCase {
    
    func test_presentController_shouldAbleToPresentCountryPickerController() {
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
    
    func test_table_numberOfRows_shouldbeEqualToTotalNumberOfCountries_whenNoSearchApplied() {
        let sut = makeSUT()
        sut.applySearch = false
        
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), CountryManager.shared.countries.count)

    }
    
    func test_whenAppliedFilter_table_numberOfRows_shouldbeEqualTo() {
        let sut = makeSUT()
        sut.applySearch = true
        sut.filterCountries = [Country(countryCode: "IN")]
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 1)
    }
    
    func test_tableView_shouldReturnCell_withRightConfiguration_withoutFilter() {
        let sut = makeSUT()
        let cell = sut.tableView.cell(at: 0) as? CountryCell
        
        XCTAssertEqual(cell?.nameLabel.text , "Afghanistan")
        XCTAssertEqual(cell?.diallingCodeLabel.text , "+93")
        XCTAssertNotNil(cell?.flagImageView)
    }
    
    func test_tableView_shouldReturnCell_withRightConfiguration_withFilter() {
        let sut = makeSUT()
        sut.filterCountries = [Country(countryCode: "IN")]
        sut.applySearch = true
        let cell = sut.tableView.cell(at: 0) as? CountryCell
        
        XCTAssertEqual(cell?.nameLabel.text , "India")
        XCTAssertEqual(cell?.diallingCodeLabel.text , "+91")
        XCTAssertNotNil(cell?.flagImageView)
    }
    
    func test_selectTableView_atIndex_shouldTriggerCallback_withRightArgument_withoutFilter() {
        var logCallbackCounter = 0
        var selectedCountry: Country?
        
        let callback:(Country) -> Void = { country in
            logCallbackCounter += 1
            selectedCountry = country
        }
        
        let sut = makeSUT(callback: callback)
        sut.tableView.select(row: 0)
        
        
        XCTAssertEqual(logCallbackCounter, 1)
        XCTAssertEqual(selectedCountry, Country(countryCode: "AF"))
    }
    
    func test_selectTableView_atIndex_shouldTriggerCallback_withRightArgument_withFilter() {
        var logCallbackCounter = 0
        var selectedCountry: Country?
        
        let callback:(Country) -> Void = { country in
            logCallbackCounter += 1
            selectedCountry = country
        }
        
        let sut = makeSUT(callback: callback)
        sut.filterCountries = [Country(countryCode: "IN"), Country(countryCode: "US")]
        sut.applySearch = true
        sut.tableView.select(row: 1)
        
        
        XCTAssertEqual(logCallbackCounter, 1)
        XCTAssertEqual(selectedCountry, Country(countryCode: "US"))
    }
    
    func test_tableViewHeightForRow() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.tableView.delegate?.tableView?(sut.tableView, heightForRowAt: IndexPath(item: 0, section: 0)), 60.0)
    }
    
    func test_shouldSetUpSeachbar() {
        let sut = makeSUT()
        let searchController = sut.navigationItem.searchController
        XCTAssertNotNil(searchController)
        
        XCTAssertEqual(searchController?.hidesNavigationBarDuringPresentation, true)
        XCTAssertEqual(searchController?.searchBar.barStyle, .default)
        XCTAssertNotNil(searchController?.searchBar.delegate)
        
        XCTAssertEqual(sut.definesPresentationContext, true)
    }
    
    func test_searchShouldAble_toReloadTableView_withRelatedCountries() {
        let sut = makeSUT()
        sut.applySearch = true 
        CountryManager.shared.filters = [.countryCode]
        sut.searchController.searchBar.simulateSearch(text: "US")
        
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 1)
    }
    
    func test_searchEmptyShouldAble_toReloadTableView_withRelatedCountries() {
        let sut = makeSUT()
        sut.applySearch = true
        CountryManager.shared.filters = [.countryCode]
        sut.searchController.searchBar.simulateSearch(text: "")

        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), CountryManager.shared.countries.count)
    }
    
    func test_searchCancelShould_reloadTableView_withoutFilter() {
        let sut = makeSUT()
        sut.applySearch = true
        CountryManager.shared.filters = [.countryCode]
        let searchBar = sut.searchController.searchBar
        searchBar.simulateSearch(text: "US")
        
        searchBar.delegate?.searchBarCancelButtonClicked?(searchBar)
        
        XCTAssertEqual(sut.applySearch, false)
        XCTAssertEqual(searchBar.text, "")
        XCTAssertEqual(searchBar.isFirstResponder, false)
        
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), CountryManager.shared.countries.count)
    }
    
    
    func test_whenKeyboardsearchbutton_clickedShould_makeResignSearchBarFirstResponder() {
        let sut = makeSUT()
        let searchBar = sut.searchController.searchBar
        searchBar.becomeFirstResponder()
        
        searchBar.delegate?.searchBarSearchButtonClicked?(searchBar)
        
        XCTAssertEqual(searchBar.isFirstResponder, false)
    }
    
    
    func test_scrollToCountry_shouldMakeTableViewScrollToIndex() {
        let sut = makeSUT()
        let country = Country(countryCode: "IN")
        guard let countryIndex = CountryManager.shared.countries.firstIndex(where: { $0.countryCode == country.countryCode}) else { return }
        sut.scrollToCountry(country)
        
        XCTAssertTrue(sut.tableView.indexPathsForVisibleRows?.contains(IndexPath(row: countryIndex, section: 0)) ?? false )
    }
    
    func test_setFavouriteCountries_shouldReloadCountriesAndTableView() {
        let sut = makeSUT()
        let favCountries = [Country(countryCode: "US"), Country(countryCode: "IN")]
        sut.favoriteCountriesLocaleIdentifiers = ["US", "IN"]
        
        XCTAssertEqual(sut.favoriteCountries, favCountries)
        XCTAssertEqual(sut.isFavoriteEnable, true)
        let cell1 = sut.tableView.cell(at: 0) as? CountryCell
        let cell2 = sut.tableView.cell(at: 1) as? CountryCell
        
        XCTAssertEqual(cell1?.nameLabel.text, "United States")
        XCTAssertEqual(cell2?.nameLabel.text, "India")
        
        XCTAssertEqual(sut.tableView.dataSource?.tableView(sut.tableView, numberOfRowsInSection: 0), CountryManager.shared.countries.count + favCountries.count)
    }
    
    //MARK: - Helpers
    func makeSUT(presentingVC: UIViewController = UIViewController(), callback:((Country) -> Void)? = nil) -> CountryPickerController {
        let sut = CountryPickerController.presentController(on: presentingVC) { country in
            callback?(country)
        }
        sut.startLifeCycle()
        return sut
    }
}


private extension UIBarButtonItem {
    func simulateTap() {
        target!.performSelector(onMainThread: action!, with: nil, waitUntilDone: true)
    }
}

extension UISearchBar {
    func simulateSearch(text: String) {
        self.text = text
        delegate?.searchBar?(self, textDidChange: text)
    }
}
