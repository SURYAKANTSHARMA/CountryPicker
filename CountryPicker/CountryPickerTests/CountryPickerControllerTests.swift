//
//  CountryPickerControllerTests.swift
//  CountryPickerTests
//
//  Created by Github on 07/01/21.
//  Copyright © 2021 SuryaKant Sharma. All rights reserved.
//

import Foundation
import XCTest

@testable import CountryPicker

class countryPickerControllerTests: XCTestCase {
        
    func test_presentController_shouldAbleToSetCallback_afterSelectCountry() {

        var logCallbackCounter = 0
        var selectedCountry: Country?

        let callback: OnSelectCountryCallback = { country in
            logCallbackCounter += 1
            selectedCountry = country
        }
        let sut = makeSUT(callback: callback)
        let country = Country(countryCode: "IN")
        sut.onSelectCountry?(country)

        XCTAssertEqual(selectedCountry, country)
        XCTAssertEqual(logCallbackCounter, 1)
    }

    func test_table_numberOfRows_shouldbeEqualToZero_whenNoSearchAppliedAndWithZeroCountry() {
        let countries = [Country]()
        let sut = makeSUT(manager: CountryManagerSpy(countries: countries))
        sut.applySearch = false

        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), countries.count)

    }
    
    func test_table_numberOfRows_shouldbeEqualToTotalNumberOfCountries_whenNoSearchApplied() {
        let countries = [Country(countryCode: "IN"),
                         Country(countryCode: "US")]
        let sut = makeSUT(manager: CountryManagerSpy(countries: countries))
        sut.applySearch = false

        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), countries.count)
    }

    func test_whenAppliedFilter_table_numberOfRows_shouldbeEqualTo() {
        let sut = makeSUT()
        sut.applySearch = true
        sut.filterCountries = [Country(countryCode: "IN")]
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 1)
    }

    func test_tableView_shouldReturnCell_withRightConfiguration_withoutFilter() {
        let managerSpy = CountryManagerSpy(countries: [Country(countryCode: "AF")])
        let sut = makeSUT(manager: managerSpy)
        let cell = sut.tableView.cell(at: 0) as? CountryCell

        XCTAssertEqual(cell?.nameLabel.text , "Afghanistan")
        XCTAssertEqual(cell?.diallingCodeLabel.text , "+93")
        XCTAssertNotNil(cell?.flagImageView)
        
        XCTAssertEqual(managerSpy.allCountriesFuncCallerCounter, 2, "Init also use allcountries function so counter will call 2 times")
        XCTAssertEqual(managerSpy.countryWithCodeFuncCallerCounter, 0)
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
        let managerSpy = CountryManagerSpy(countries: [Country(countryCode: "AF"), Country(countryCode: "IN")])

        var selectedCountry: Country?

        let callback: OnSelectCountryCallback = { country in
            logCallbackCounter += 1
            selectedCountry = country
        }
        
        let sut = makeSUT(manager: managerSpy, callback: callback)
        sut.tableView.select(row: 0)


        XCTAssertEqual(logCallbackCounter, 1)
        XCTAssertEqual(selectedCountry, Country(countryCode: "AF"))
        XCTAssertEqual(managerSpy.lastCountrySelected, selectedCountry)
        XCTAssertEqual(managerSpy.lastCountrySelected, selectedCountry)
    }

    func test_selectTableView_atIndex_shouldTriggerCallback_withRightArgument_withFilter() {
        var logCallbackCounter = 0
        var selectedCountry: Country?

        let callback: OnSelectCountryCallback = { country in
            logCallbackCounter += 1
            selectedCountry = country
        }

        let managerSpy = CountryManagerSpy(countries: [Country(countryCode: "AF"), Country(countryCode: "IN"), Country(countryCode: "US")])

        let sut = makeSUT(manager: managerSpy, callback: callback)
        sut.applySearch = true
        sut.filterCountries = [Country(countryCode: "IN"), Country(countryCode: "US")]
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
        let totalCountries = [Country(countryCode: "AF"),
                              Country(countryCode: "IN"),
                              Country(countryCode: "US")]
        
        let managerSpy = CountryManagerSpy(countries: totalCountries)

        let sut = makeSUT(manager: managerSpy)
        sut.engine = CountryPickerEngine(countries: totalCountries, filterOptions: [.countryCode])
        sut.applySearch = true
        sut.searchController.searchBar.simulateSearch(text: "US")
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 1)
    }

    func test_searchEmptyShouldAble_toReloadTableView_withRelatedCountries() {
        let countries = [Country(countryCode: "AF"), Country(countryCode: "IN"), Country(countryCode: "US")]
        let managerSpy = CountryManagerSpy(countries: countries)

        let sut = makeSUT(manager: managerSpy)
        sut.applySearch = true
        sut.searchController.searchBar.simulateSearch(text: "")
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), countries.count)
    }

    func test_searchCancelShould_reloadTableView_withoutFilter() {
        let countries = [Country(countryCode: "AF"), Country(countryCode: "IN"), Country(countryCode: "US")]
        let managerSpy = CountryManagerSpy(countries: countries)

        let sut = makeSUT(manager: managerSpy)
        sut.applySearch = true
        let searchBar = sut.searchController.searchBar
        searchBar.simulateSearch(text: "US")

        searchBar.delegate?.searchBarCancelButtonClicked?(searchBar)

        XCTAssertEqual(sut.applySearch, false)
        XCTAssertEqual(searchBar.text, "")
        XCTAssertEqual(searchBar.isFirstResponder, false)

        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), countries.count)
    }


    func test_whenKeyboardsearchbutton_clickedShould_makeResignSearchBarFirstResponder() {
        let sut = makeSUT()
        let searchBar = sut.searchController.searchBar
        searchBar.becomeFirstResponder()

        searchBar.delegate?.searchBarSearchButtonClicked?(searchBar)

        XCTAssertEqual(searchBar.isFirstResponder, false)
    }


    func test_scrollToCountry_shouldMakeTableViewScrollToIndex() {
        let countries = [Country(countryCode: "AF"), Country(countryCode: "IN"), Country(countryCode: "US")]
        let managerSpy = CountryManagerSpy(countries: countries)

        let sut = makeSUT(manager: managerSpy)
        let country = Country(countryCode: "IN")
        
        guard let countryIndex = countries.firstIndex(where: { $0.countryCode == country.countryCode}) else { return }
        sut.scrollToCountry(country)

        XCTAssertTrue(sut.tableView.indexPathsForVisibleRows?.contains(IndexPath(row: countryIndex, section: 0)) ?? false )
    }

    func test_setFavouriteCountries_shouldReloadCountriesAndTableView() {
        let countries = [Country(countryCode: "AF"), Country(countryCode: "IN"), Country(countryCode: "US")]
        let favCountries = [Country(countryCode: "US"), Country(countryCode: "IN")]

        let managerSpy = CountryManagerSpy(countries: countries, favouriteCountries: favCountries)

        let sut = makeSUT(manager: managerSpy)
        sut.favoriteCountriesLocaleIdentifiers = ["US", "IN"]

        XCTAssertEqual(sut.favoriteCountries, favCountries)
        XCTAssertEqual(sut.isFavoriteEnable, true)
        let cell1 = sut.tableView.cell(at: 0) as? CountryCell
        let cell2 = sut.tableView.cell(at: 1) as? CountryCell

        XCTAssertEqual(cell1?.nameLabel.text, "United States")
        XCTAssertEqual(cell2?.nameLabel.text, "India")
        XCTAssertEqual(sut.tableView.dataSource?.tableView(sut.tableView, numberOfRowsInSection: 0), countries.count + favCountries.count)
        XCTAssertEqual(managerSpy.allCountriesFuncCallerCounter, 3)
    }
    
    //MARK: - Helpers
    func makeSUT(presentingVC: UIViewController = UIViewController(),
                 manager: CountryListDataSource = CountryManagerSpy(),
                 callback: OnSelectCountryCallback? = nil) -> CountryPickerController {
        let sut = CountryPickerController(manager: manager)
        sut.onSelectCountry = callback
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


class CountryManagerSpy: CountryListDataSource {
    var countryWithCodeFuncCallerCounter = 0
    var allCountriesFuncCallerCounter = 0
    
    let countries: [Country]
    let favouriteCountries: [Country]
    private var _lastCountrySelected: Country?
    
    init(countries: [Country] = [],
         lastCountrySelected: Country? = nil,
         favouriteCountries: [Country] = []) {
        self.countries = countries
        _lastCountrySelected = lastCountrySelected
        self.favouriteCountries = favouriteCountries
    }
    
    func country(withCode code: String) -> Country? {
        countryWithCodeFuncCallerCounter += 1
        return countries.first { $0.countryCode == code }
    }
    
    func allCountries(_ favoriteCountriesLocaleIdentifiers: [String]) -> [Country] {
        allCountriesFuncCallerCounter += 1
        return  favouriteCountries + countries
    }
    
    var lastCountrySelected: Country? {
        get { _lastCountrySelected}
        set {_lastCountrySelected = newValue}
    }
}
