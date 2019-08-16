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
public enum CountryFilterOptions {
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
    
    var lastCountrySelected: Country?
    
    /// Current country returns the country object from Phone/Simulator locale
    open var currentCountry: Country? {
        
        let locale = Locale.current as NSLocale
        
        guard let countryCode = locale.object(forKey: .countryCode) as? String else {
            return nil
        }
        
        return Country(countryCode: countryCode)
    }
    
    /// Default country filter option
    internal let defaultFilter: CountryFilterOptions = .countryName
    
    /// Exposed country filter options and should be configured by user
    ///
    /// - Note: By default, countries can be filtered by there country names
    public var filters: [CountryFilterOptions] = [.countryName]
    
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

// MARK: - Error Handling
extension String: Error {}
extension String: LocalizedError {
    public var errorDescription: String? { return self }
}
