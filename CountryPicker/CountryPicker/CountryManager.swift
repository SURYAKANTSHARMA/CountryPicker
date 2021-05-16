//
//  CountryManager.swift
//  CountryCodeInSwift3
//
//  Created by Cl-macmini-100 on 12/19/16.
//  Copyright © 2016 Suryakant. All rights reserved.
//

import Foundation
import UIKit


/// Country filtering options
public enum CountryFilterOption {
    /// Filter countries by country name
    case countryName
    
    /// Filter countries by country code
    case countryCode
    
    /// Filter countries by country dial code
    case countryDialCode
}


open class CountryManager {
    
    // MARK: - variable
    public var countries = [Country]()
    
    private var countriesFilePath: String? {
        #if SWIFT_PACKAGE
            let bundle = Bundle.module
        #else
            let bundle = Bundle(for: CountryManager.self)
        #endif
        
        let countriesPath = bundle.path(forResource: "CountryPickerController.bundle/countries", ofType: "plist")
        return countriesPath
    }
    
    public static var shared: CountryManager = {
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
        guard let countryCode = Locale.current.regionCode else {
            return nil
        }
        return Country(countryCode: countryCode)
    }
    
    
    internal var lastCountrySelected: Country?
    
    /// Default country filter option
    internal let defaultFilter: CountryFilterOption = .countryName
    
    /// Exposed country filter options and should be configured by user
    ///
    /// - Note: By default, countries can be filtered by there country names
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
            throw "[CountryManager] ❌ Missing countries plist file from path: \(path)"
        }
        
        // Sort country list by `countryName`
        let sortedCountries = countryCodes.map { Country(countryCode: $0) }.sorted { $0.countryName < $1.countryName }
        
        #if DEBUG
        print("[CountryManager] ✅ Succefully prepared list of \(sortedCountries.count) countries")
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
    
    /// As the function name, resets the last selected country
    func resetLastSelectedCountry() {
        lastCountrySelected = nil
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
            
            // Remove a plus sign if does exists
            if dialCode.contains("+"), let plusSignIndex = dialCode.firstIndex(of: "+") {
                dialCode.remove(at: plusSignIndex)
            }
            
            return dialCode == countryDialCode
        })
    }
}


// MARK: - CountryFilterOption Methods
public extension CountryManager {
    
    ///  Adds a new filter into `filters` collection with no duplicates
    ///
    /// - Parameter filter: New filter to be added
    
    func addFilter(_ filter: CountryFilterOption) {
        filters.insert(filter)
    }
    
    
    /// Removes a given filter from `filters` collection
    ///
    /// - Parameter filter: A filter to b removed
    
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


// MARK: - Error Handling
extension String: Error {}
extension String: LocalizedError {
    public var errorDescription: String? { return self }
}
