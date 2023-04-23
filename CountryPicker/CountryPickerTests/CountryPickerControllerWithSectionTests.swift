//
//  CountryPickerControllerWithSectionTests.swift
//  CountryPickerTests
//
//  Created by Github on 08/01/21.
//  Copyright © 2021 SuryaKant Sharma. All rights reserved.
//

import Foundation
import XCTest
@testable import CountryPicker

class CountryPickerControllerWithSectionTests: XCTestCase {
            
    func test_presentController_shouldAbleToSetCallback() {

        var logCallbackCounter = 0
        var selectedCountry: Country?

        let callback:(Country) -> Void = { country in
            logCallbackCounter += 1
            selectedCountry = country
        }
        let sut = makeSUT(callback: callback)
        let country = Country(countryCode: "IN")
        sut.onSelectCountry?(country)


        XCTAssertEqual(selectedCountry, country)
        XCTAssertEqual(logCallbackCounter, 1)
    }

    func test_table_numberOfSection_equalToUniqueCountries() {
        let sut = makeSUT()
        sut.applySearch = false

        sut.countries = [Country(countryCode: "IN"), Country(countryCode: "US"), Country(countryCode: "IDN")]
        sut.fetchSectionCountries()


        XCTAssertEqual(sut.sections, ["I", "U"])
        XCTAssertEqual(sut.sectionCoutries["I"]?.contains(Country(countryCode: "IN")), true)
        XCTAssertEqual(sut.sectionCoutries["I"]?.contains(Country(countryCode: "IDN")), true)
        XCTAssertEqual(sut.sectionCoutries["U"]?.contains(Country(countryCode: "US")), true)

        sut.favoriteCountriesLocaleIdentifiers = ["IN"]
        sut.fetchSectionCountries()
    }

    func test_scrollToCountryShould_scrollTableViewToContryIndexPath() {
        let sut = makeSUT(manager: makeSpy())
        sut.applySearch = false
        sut.loadCountries()
        let countryUnderTest = Country(countryCode: "IN")
        let row = sut.sectionCoutries["I"]?
            .firstIndex(where: { $0.countryCode == countryUnderTest.countryCode}) ?? 0
        let section =  sut.sectionCoutries.keys.map { $0 }.sorted().firstIndex(of: "I") ?? 0

        sut.scrollToCountry(Country(countryCode: "IN"), withSection: countryUnderTest.countryName.first!, animated: false)


        XCTAssertTrue(sut.tableView.indexPathsForVisibleRows?.contains(IndexPath(row: row, section: section)) ?? false )
    }

    func test_scrollToCountryShould_whenApplySearchShouldNotScroll() {
        let sut = makeSUT(manager: makeSpy())
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
        let sut = makeSUT(manager: makeSpy())
        sut.applySearch = true

        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), sut.filterCountries.count)

        sut.favoriteCountriesLocaleIdentifiers = ["IN"]
        XCTAssertEqual(sut.tableView.dataSource?.tableView(sut.tableView, numberOfRowsInSection: 0), sut.filterCountries.count)
    }

    func test_numberOfRowsInSection_withoutAppliedSeach_shouldShowCountryOnSection() {
        let sut = makeSUT(manager: makeSpy())
        sut.applySearch = false

        let section = 0
        let rowsCount = sut.tableView.dataSource?.tableView(sut.tableView, numberOfRowsInSection: section)
        XCTAssertEqual(rowsCount, sut.firstSectionCount)
    }

    func test_numberOfRowsInSection_withoutAppliedSeach_withFavourites() {
        let sut = makeSUT(manager: makeSpy())
        sut.applySearch = false
        let favouriteIdetifiers = ["AF", "US"]
        sut.favoriteCountriesLocaleIdentifiers = favouriteIdetifiers


        XCTAssertEqual(sut.tableView.dataSource?.tableView(sut.tableView, numberOfRowsInSection: 0), favouriteIdetifiers.count)

        XCTAssertEqual(sut.tableView.dataSource?.tableView(sut.tableView, numberOfRowsInSection: 1), sut.firstSectionCount)
    }

    func test_titleForHeaderInSectionInRow_withAppliedSearch_shouldReturnSearchTitle() {
        let sut = makeSUT(manager: makeSpy())
        let tableView = sut.tableView
        sut.applySearch = true

        XCTAssertEqual(tableView.dataSource?.tableView?(tableView, titleForHeaderInSection: 0), "A")
    }

    func test_titleForHeaderInSectionInRow_withoutAppliedSearch_shouldReturnSearchTitle() {
        let sut = makeSUT(manager: makeSpy())

        let tableView = sut.tableView
        sut.applySearch = false

        XCTAssertEqual(tableView.dataSource?.tableView?(tableView, titleForHeaderInSection: 0), "A")

        sut.favoriteCountriesLocaleIdentifiers = ["IN"]
        XCTAssertNil(tableView.dataSource?.tableView?(tableView, titleForHeaderInSection: 0))
    }

    func test_cellConfiguration_ofTableView_withoutAppliedSearch() {
        let sut = makeSUT(manager: makeSpy())

        let tableView = sut.tableView
        sut.applySearch = false

        let cell = tableView.dataSource?.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? CountryCell
        XCTAssertEqual(cell?.country, Country(countryCode: "AF"))
    }

    func test_cellConfiguration_ofTableView_withAppliedSearch() {
        let sut = makeSUT()
        let tableView = sut.tableView

        sut.filterCountries = [Country(countryCode: "IN")]
        sut.applySearch = true

        let cell = tableView.dataSource?.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? CountryCell
        XCTAssertEqual(cell?.country, Country(countryCode: "IN"))
    }

    func test_cellConfiguration_ofTableView_withoutAppliedSearchWithFavourite() {
        let countryManager = makeSpy()
        countryManager.lastCountrySelected =  Country(countryCode: "IN")
        let sut = makeSUT(manager: countryManager)

        let tableView = sut.tableView

        sut.favoriteCountriesLocaleIdentifiers = ["IN", "US"]
        sut.applySearch = false

        let cell = tableView.dataSource?.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? CountryCell
        XCTAssertEqual(cell?.country, Country(countryCode: "IN"))
        XCTAssertEqual(cell?.checkMarkImageView.isHidden, false)

        let cell2 = tableView.dataSource?.tableView(tableView, cellForRowAt: IndexPath(row: 1, section: 0)) as? CountryCell
        XCTAssertEqual(cell2?.country, Country(countryCode: "US"))

        let cell3 = tableView.dataSource?.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 1)) as? CountryCell
        XCTAssertEqual(cell3?.country, Country(countryCode: "AF"))
    }


    func test_sectionForIndexTitles() {
        let sut = makeSUT(manager: makeSpy())
        let tableView = sut.tableView
        let sectionTitle = tableView.dataSource?.sectionIndexTitles?(for: tableView) ?? []
        XCTAssertEqual(sectionTitle, sut.sections.map {String($0)})
    }
    
    func test_titleForSectionIndex() {
        let sut = makeSUT(manager: makeSpy())
        let tableView = sut.tableView
        let character = "A"
        let index = tableView.dataSource?.tableView?(tableView, sectionForSectionIndexTitle: character, at: 0)
        let matchIndex = sut.sections.firstIndex(of: Character(character))
        XCTAssertNotNil(matchIndex)
        XCTAssertEqual(index, matchIndex!)
    }

    func test_searchEmptyShouldAble_toReloadTableView_withRelatedCountries() {
        let totalCountries = [Country(countryCode: "AF"),
                              Country(countryCode: "IN"),
                              Country(countryCode: "US")]
        
        let manager = makeSpy()
        let sut = makeSUT(manager: manager)
        sut.engine = CountryPickerEngine(countries: totalCountries, filterOptions: [.countryCode])

        sut.applySearch = true
        sut.searchController.searchBar.simulateSearch(text: "IN")

        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 1)
        XCTAssertEqual(sut.searchHeaderTitle, "I")
    }

    func test_tableView_didSelectShould_triggerCallbackWithRightCountry_withUserSearch() {
        let totalCountries = [Country(countryCode: "AF"),
                              Country(countryCode: "IN"),
                              Country(countryCode: "US")]

        var logCallbackCounter = 0
        var selectedCountry: Country?
        let callback:(Country) -> Void = { country in
            logCallbackCounter += 1
            selectedCountry = country
        }
        
        let countryManager = makeSpy()
        let sut = makeSUT(manager: countryManager,callback: callback)
        sut.engine = CountryPickerEngine(countries: totalCountries, filterOptions: [.countryCode])

        sut.searchController.searchBar.simulateSearch(text: "IN")
        sut.tableView.select(row: 0)

        XCTAssertEqual(countryManager.lastCountrySelected, totalCountries[1])
        XCTAssertNotNil(selectedCountry)
        XCTAssertEqual(selectedCountry!, totalCountries[1])
        XCTAssertEqual(logCallbackCounter, 1)
    }

    func test_tableView_didSelectShould_triggerCallbackWithRightCountry_withoutUserSearch_withFavourite() {
        var logCallbackCounter = 0
        var selectedCountry: Country?
        let india = Country(countryCode: "IN")
        let unitedStates = Country(countryCode: "US")
        let afganistan = Country(countryCode: "AF")

        let callback:(Country) -> Void = { country in
            logCallbackCounter += 1
            selectedCountry = country
        }

        let countryManager = makeSpy()
        countryManager.lastCountrySelected = nil
        let sut = makeSUT(manager: countryManager, callback: callback)
        sut.favoriteCountriesLocaleIdentifiers = ["IN", "US"]
        sut.tableView.select(row: 0)

        XCTAssertEqual(selectedCountry, india)
        XCTAssertEqual(logCallbackCounter, 1)
        XCTAssertEqual(countryManager.lastCountrySelected, india)

        sut.tableView.select(row: 1)

        XCTAssertEqual(selectedCountry, unitedStates)
        XCTAssertEqual(logCallbackCounter, 2)
        XCTAssertEqual(countryManager.lastCountrySelected, unitedStates)

        sut.tableView.select(row: 0, section: 1)

        XCTAssertEqual(selectedCountry, afganistan)
        XCTAssertEqual(logCallbackCounter, 3)
        XCTAssertEqual(countryManager.lastCountrySelected, afganistan)
    }

    func test_tableView_didSelectShould_triggerCallbackWithRightCountry_withoutUserSearch_withoutFavouriteSet() {
        var logCallbackCounter = 0
        var selectedCountry: Country?
        let afganistan = Country(countryCode: "AF")
        let callback:(Country) -> Void = { country in
            logCallbackCounter += 1
            selectedCountry = country
        }
        let countryManager = makeSpy()
        countryManager.lastCountrySelected = nil
        let sut = makeSUT(manager: countryManager, callback: callback)
        sut.tableView.select(row: 0)

        XCTAssertEqual(selectedCountry, afganistan)
        XCTAssertEqual(logCallbackCounter, 1)
        XCTAssertEqual(countryManager.lastCountrySelected, afganistan)
    }

    func test_scrollToPreviousShould_scrollToPreviousCountryInTableView() {
        let sut =  makeSUT(manager: makeSpy())
        let india = Country(countryCode: "IN")
        sut.loadCountries()
        sut.scrollToPreviousCountryIfNeeded()
        let isIndiaCellVisible = sut.tableView.visibleCells.filter { cell in
            guard let cell = cell as? CountryCell else { return false }
            return cell.country == india
        }.compactMap{$0}.first
        XCTAssertNotNil(isIndiaCellVisible)
    }

    func test_scrollToPreviousShould_scrollToPreviousCountryInTableView_whenFavouriteEnable() {
        let favouriteCountryIdentifiers = ["US",
                                           "IN"]

        let manager = CountryManagerSpy(countries: [Country(countryCode: "AF"),
                                      Country(countryCode: "US")],
                                        favouriteCountries: favouriteCountryIdentifiers.compactMap { Country(countryCode: $0)
        })
        let sut = makeSUT(manager: manager)
        sut.favoriteCountriesLocaleIdentifiers = favouriteCountryIdentifiers
        let india = Country(countryCode: "IN")
        sut.loadCountries()
        
        manager.lastCountrySelected = india
        sut.scrollToPreviousCountryIfNeeded()
        let isIndiaCellCount = sut.tableView.visibleCells.filter { cell in
            guard let cell = cell as? CountryCell else { return false }
            return cell.country == india
        }.compactMap{$0}.count
        XCTAssertEqual(isIndiaCellCount, 1)
    }
    
//    func test_inFilterCountries_whenSelected_shouldDismissCountryController() {
//        
//        // Given
//        var logCallbackCounter = 0
//        var selectedCountry: Country?
//        let india = Country(countryCode: "IN")
//        let callback:(Country) -> Void = { country in
//            logCallbackCounter += 1
//            selectedCountry = country
//        }
//        let countryManager = makeSpy()
//        countryManager.lastCountrySelected = nil
//        let rootVC = UIViewController()
//        
//        let navigation = UINavigationController(rootViewController: rootVC)
//        
//        let window = UIWindow(frame: UIScreen.main.bounds)
//        window.rootViewController = navigation
//        window.makeKeyAndVisible()
//
//        
//        let sut = makeSUT(manager: countryManager,
//                          presentingVC: rootVC, callback: callback)
//
//        XCTAssertEqual(sut.presentingViewController, navigation)
//
//        // when
//        sut.searchController.searchBar.becomeFirstResponder()
//        sut.searchController.searchBar.simulateSearch(text: "IN")
//        sut.tableView.select(row: 0)
//
//        // then
//        XCTAssertNil(sut.presentingViewController)
//    }
    
    //MARK: - Helpers
    func makeSUT(manager: CountryListDataSource = CountryManagerSpy(),
                 presentingVC: UIViewController = UIViewController(), callback:((Country) -> Void)? = nil) -> CountryPickerWithSectionViewController {
        let sut = CountryPickerWithSectionViewController(manager: manager)
        sut.onSelectCountry = callback
        sut.startLifeCycle()
        presentingVC.present(sut, animated: false)
        return sut
    }

    
    func makeSpy(_ countries: [Country] = defaultCountries) -> CountryManagerSpy {
      CountryManagerSpy(countries: countries)
    }
}

private extension CountryPickerWithSectionViewController {
    var firstSectionCount: Int {
        sectionCoutries["A"]!.count
    }
}

private let defaultCountries =
    [Country(countryCode: "IN"),
     Country(countryCode: "AF"),
     Country(countryCode: "US")]

extension CountryPickerWithSectionViewController {
    open override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: false,
                      completion: completion)
    }
}
