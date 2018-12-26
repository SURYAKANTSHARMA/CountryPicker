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
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            let country = Country(countryCode: countryCode)
            return country
        }
        return nil
    }
    
    private init() {
    }
    
    func loadCountries() throws {
        let bundle = Bundle(for: CountryManager.self)
        if let countriesPath = bundle.path(forResource: "CountryPickerController.bundle/countries", ofType: "plist"),
            let  array = (NSArray(contentsOfFile: countriesPath) as? [String]) {
            self.countries.removeAll()
            array.forEach {
                self.countries.append(Country(countryCode: $0))
            }
            self.countries = self.countries.sorted { $0.countryName < $1.countryName }
        } else {
            throw "Missing array of countries plist in CountryPicker"
        }
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
