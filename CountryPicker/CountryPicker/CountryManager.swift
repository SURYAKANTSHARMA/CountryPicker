//
//  CountryManager.swift
//  CountryCodeInSwift3
//
//  Created by Cl-macmini-100 on 12/19/16.
//  Copyright © 2016 Suryakant. All rights reserved.
//

import Foundation
import UIKit

open class CountryManager {
    
    // MARK: - variable
    private(set) var countries = [Country]()
    
    private var countriesFilePath: String? {
        let bundle = Bundle(for: CountryManager.self)
        let countriesPath = bundle.path(forResource: "CountryPickerController.bundle/countries", ofType: "plist")
        return countriesPath
    }
    
    public static var shared: CountryManager = {
        let countryManager = CountryManager()
        do { try countryManager.loadCountries()
        } catch {
            print(error.localizedDescription)
        }
        return countryManager
    }()
    
    /// Current country returns the country object from Phone/Simulator locale
    open var currentCountry: Country? {
        
        let locale = Locale.current as NSLocale
        
        guard let countryCode = locale.object(forKey: .countryCode) as? String else {
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
    
    
    func loadCountries() throws {
        
        guard let countriesFilePath = countriesFilePath,
              let countryCodes = NSArray(contentsOfFile: countriesFilePath) as? [String] else {
              throw "Missing array of countries plist in CountryPicker"
        }
        
        // Clear old loaded countries
        countries.removeAll()
        
        // Request for fresh copy of sorted country list
        let sortedCountries = countryCodes.map { Country(countryCode: $0) }.sorted { $0.countryName < $1.countryName }
        
        countries.append(contentsOf: sortedCountries)
    }

    func allCountries() -> [Country] {
        return countries
    }
}


// MARK: - Country Filter Methods
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
        filters = filters.filter { $0 != filter }
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
