//
//  CountryManager.swift
//  CountryCodeInSwift3
//
//  Created by Cl-macmini-100 on 12/19/16.
//  Copyright © 2016 Suryakant. All rights reserved.
//

import Foundation
import UIKit

// MARK: - CountryManagerInterface
public protocol CountryListDataSource: ObservableObject {
    func country(withCode code: String) -> Country?
    func allCountries(_ favoriteCountriesLocaleIdentifiers: [String]) -> [Country]
    var lastCountrySelected: Country? { get set }
    func filterCountries(searchText: String) -> [Country]
}

// MARK: - CountryManagerInterface extension for optional variables and default implementation
extension CountryListDataSource {
    var lastCountrySelected: Country? {
        get { nil }
        set {}
    }
}

// MARK: - CountryFilterOption
/// Country filtering options
public enum CountryFilterOption {
    /// Filter countries by country name
    case countryName
    
    /// Filter countries by country code
    case countryCode
    
    /// Filter countries by country dial code
    case countryDialCode
}

#if SWIFT_PACKAGE
let bundle = Bundle.module
#else
let bundle = Bundle(for: Country.self)
#endif

// MARK: - CountryManager

public enum CountryManagerError: Error {
    case missingCountriesFile(path: String)
}

open class CountryManager: CountryListDataSource {
    
    // MARK: - Variables
    @Published public var countries = [Country]()
    
    private var countriesFilePath: String? {
        let countriesPath = bundle.path(forResource: "CountryPickerController.bundle/countries", ofType: "plist")
        return countriesPath
    }
    
    public static let shared: CountryManager = {
        let countryManager = CountryManager()
        do {
            try countryManager.loadCountries()
        } catch {
            #if DEBUG
            print(error.localizedDescription)
            #endif
        }
        return countryManager
    }()
    
    /// Current country returns the country object from Phone/Simulator locale
    open var currentCountry: Country? {
        if #available(iOS 16, *) {
            guard let countryCode = Locale.current.language.region?.identifier else {
                return nil
            }
            return Country(countryCode: countryCode)

        } else {
            guard let countryCode = Locale.current.regionCode else {
                return nil
            }
            return Country(countryCode: countryCode)
        }
    }
    
    open var preferredCountry: Country? {
        lastCountrySelected ?? currentCountry
    }
    
    public var lastCountrySelected: Country?
    
    /// Default country filter option
    internal let defaultFilter: CountryFilterOption = .countryName
    
    /// Exposed country filter options and should be configured by user
    ///
    /// - Note: By default, countries can be filtered by their country names
    internal var filters: Set<CountryFilterOption> = [.countryName]
    
    private init() {}
}

public extension CountryManager {
    
    /// Fetch country list from a given property list file path
    ///
    /// - Parameter path: URL for the country plist file path
    /// - Returns: A list of countries sorted by `CountryName`
    
    func fetchCountries(fromURLPath path: URL) throws -> [Country] {
        guard let rawData = try? Data(contentsOf: path),
              let countryCodes = try? PropertyListSerialization.propertyList(from: rawData, format: nil) as? [String] else {
            throw CountryManagerError.missingCountriesFile(path: path.absoluteString)
        }
        
        // Sort country list by `countryName`
        let sortedCountries = countryCodes.map { Country(countryCode: $0) }.sorted { $0.countryName < $1.countryName }
        
        #if DEBUG
        print("[CountryManager] ✅ Successfully prepared list of \(sortedCountries.count) countries")
        #endif
        
        return sortedCountries
    }
    
    /// Prepares a country list object for usage while clearing any cached countries
    ///
    /// - Throws: Incase country list preperation fails to determine or convert data from a given URL file path.
    func loadCountries() throws {
        let url = URL(fileURLWithPath: countriesFilePath ?? "")
        let fetchedCountries = try fetchCountries(fromURLPath: url)
        countries.removeAll()
        countries.append(contentsOf: fetchedCountries)
    }
    
    func allCountries(_ favoriteCountriesLocaleIdentifiers: [String]) -> [Country] {
        favoriteCountriesLocaleIdentifiers
            .compactMap { country(withCode: $0) } + countries
    }
    
     /// As the function name suggests, resets the last selected country
    func resetLastSelectedCountry() {
        lastCountrySelected = nil
    }
    
    func filterCountries(searchText: String) -> [Country] {
        countries.compactMap { (country) -> Country? in
            // Filter country by country name first character
            if filters.contains(.countryName), country.countryName.capitalized.contains(searchText.capitalized) {
                return country
            }
            
            // Filter country by country code and utilize `CountryFilterOptions`
            if filters.contains(.countryCode), country.countryCode.capitalized.contains(searchText.capitalized) {
                return country
            }
            
            // Filter country by digit country code and utilize `CountryFilterOptions`
            if filters.contains(.countryDialCode), let digitCountryCode = country.digitCountrycode, digitCountryCode.contains(searchText) {
                return country
            }
            return nil
        }.removeDuplicates()
    }
}

// MARK: - Country Filter Methods
public extension CountryManager {
    
    /// Requests for a `Country` instance based on country code
    ///
    /// - Parameter code: A country code
    /// - Returns: A country instance
    
    func country(withCode code: String) -> Country? {
        countries.first(where: { $0.countryCode.lowercased() == code.lowercased() })
    }
    
    /// Requests for a `Country` instance based on country name
    ///
    func country(withName countryName: String) -> Country? {
        countries.first(where: { $0.countryName.lowercased() == countryName.lowercased() })
    }
    
    /// Requests for a `Country` instance based on country digit code
    ///
    /// Note: Country dial code should not include a plus sign at the beginning e.g: +255, +60.
    ///
    /// - Parameter dialCode:
    func country(withDigitCode dialCode: String) -> Country? {
        countries.first(where: { (country) -> Bool in
            guard let countryDialCode = country.digitCountrycode else {
                return false
            }
            
            var dialCode = dialCode
            
            // Remove a plus sign if it exists
            if dialCode.contains("+"), let plusSignIndex = dialCode.firstIndex(of: "+") {
                dialCode.remove(at: plusSignIndex)
            }
            
            return dialCode == countryDialCode
        })
    }
}

// MARK: - CountryFilterOption Methods
public extension CountryManager {
    
    /// Adds a new filter into `filters` collection with no duplicates
    ///
    /// - Parameter filter: New filter to be added
    
    func addFilter(_ filter: CountryFilterOption) {
        filters.insert(filter)
    }
    
    /// Removes a given filter from `filters` collection
    ///
    /// - Parameter filter: A filter to be removed
    
    func removeFilter(_ filter: CountryFilterOption) {
        filters.remove(filter)
    }
    
    /// Removes all stored filters from `filter` collection
    ///
    /// - Note: By default, it configures a default filter ~ `CountryFilterOptions.countryName`
    
    func clearAllFilters() {
        filters.removeAll()
        filters.insert(defaultFilter) // Set default filter option
    }
}

// MARK: - Array Extension
extension Array where Element: Hashable {
    func removeDuplicates() -> [Element] {
        var seen = Set<Element>()
        var uniqueValues = [Element]()
        for element in self {
            if !seen.contains(element) {
                uniqueValues.append(element)
                seen.insert(element)
            }
        }
        return uniqueValues
    }
}
