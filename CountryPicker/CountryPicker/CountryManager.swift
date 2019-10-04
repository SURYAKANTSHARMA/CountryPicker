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
    private(set) var countries = [Country]()
    private(set) var dialingCodes = [String: String]()
    
    private var countriesFilePath: String? {
        let bundle = Bundle(for: CountryManager.self)
        let countriesPath = bundle.path(forResource: "CountryPickerController.bundle/countries", ofType: "plist")
        return countriesPath
    }

    private var dialingCodesPath: String? {
        let bundle = Bundle(for: CountryManager.self)
        let countriesPath = bundle.path(forResource: "CountryPickerController.bundle/dialingcodes", ofType: "plist")
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
        
        guard let countryCode = locale.object(forKey: .countryCode) as? String,
            let dialingCode = dialingCodes[countryCode.lowercased()] else {
            return nil
        }
        
        return Country(countryCode: countryCode, dialingCode: dialingCode)
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

        guard let dialingCodesPath = dialingCodesPath,
            let dialingCodes = NSDictionary(contentsOfFile: dialingCodesPath) as? [String: String] else {
                throw "Missing dictionary of dialing codes in Country Picker"
        }

        let sortedCountries: [Country] = countryCodes.map {
            Country(countryCode: $0.lowercased(), dialingCode: dialingCodes[$0.lowercased()])
        }.sorted { $0.countryName < $1.countryName }

        self.countries = sortedCountries
        self.dialingCodes = dialingCodes
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
    
    
    /// Requests for a `Country` instance based on country code
    ///
    /// - Parameter code: A country code
    /// - Returns: A country instance
    
    func country(withCode code: String) -> Country? {
        return countries.first(where: { $0.countryCode.lowercased() == code.lowercased() })
    }
    
    
    /// Requests for a `Country` instance based on country name
    ///
    ///
    func country(withName countryName: String) -> Country? {
        return countries.first(where: { $0.countryName.lowercased() == countryName.lowercased() })
    }
    
    
    /// Requests for a `Country` instance based on country digit code
    ///
    /// Note: Country dial code should not include a plus sign at the beginning e.g: +255, +60.
    ///
    /// - Parameter dialCode:
    func country(withDigitCode dialCode: String) -> Country? {
        return countries.first {
            return $0.dialingCode?.contains(dialCode) ?? false
        }
    }
}


// MARK: - Error Handling
extension String: Error {}
extension String: LocalizedError {
    public var errorDescription: String? { return self }
}
