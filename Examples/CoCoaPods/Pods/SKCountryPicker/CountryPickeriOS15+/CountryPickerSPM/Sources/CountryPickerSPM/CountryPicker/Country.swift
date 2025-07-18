//
//  Country.swift
//  CountryCodeInSwift3
//
//  Created by Cl-macmini-100 on 12/19/16.
//  Copyright © 2016 Suryakant. All rights reserved.
//

import Foundation
import UIKit

open class Country: Identifiable {

    // MARK:- Variable
    open var countryCode: String

    /// Name of the country
    open var countryName: String
    
    /// - Returns: Dialing code for country instance with a `+` sign
    open var dialingCode: String? {
        guard let digitCountrycode = digitCountrycode else {
            return nil
        }
        
        return "+" + digitCountrycode
    }
    
    /// - Returns: Digit country code without a `+` sign
    open var digitCountrycode: String? {
        return isoToDigitCountryCodeDictionary[countryCode]
    }
    
    /// Image (Flag) of country
    open var flag: UIImage? {
        if image != nil {
            return image
        }
        
        #if SWIFT_PACKAGE
            let bundle = Bundle.module
        #else
            let bundle = Bundle(for: Country.self)
        #endif
        
        let flagImg = UIImage(named: imagePath, in: bundle, compatibleWith: nil)
        image = flagImg
        return image
    }

    var imagePath: String
    private var image: UIImage?

    // MARK: - Initializers
    public init(countryCode code: String) {
        self.countryCode = code
        countryName = Self.mapCountryName(self.countryCode)
        imagePath = "CountryPickerController.bundle/\(self.countryCode)"
    }

    func countryName(with locale: Locale) -> String {
        guard let localisedCountryName = locale.localizedString(forRegionCode: self.countryCode) else {
            print("Warning: Failed to localize country name for Country Code: \(self.countryCode) with locale: \(locale.identifier). Falling back to country code.")
            return self.countryCode
        }
        return localisedCountryName
    }

    func countryName(withLocaleIdentifier localeIdentifier: String) -> String {
        let locale = Locale(identifier: localeIdentifier)
        return self.countryName(with: locale)
    }
    
    static func mapCountryName(_ countryCode: String) -> String {
        let locale = Locale(identifier: Locale.preferredLanguages.first ?? "en_US") // Default to en_US if preferredLanguages is empty
        guard let localisedCountryName = locale.localizedString(forRegionCode: countryCode) else {
            print("Warning: Failed to map country name for Country Code: \(countryCode) with preferred locale: \(locale.identifier). Falling back to country code.")
            return countryCode
        }
        return localisedCountryName
    }

}


extension Country: Equatable {
    public static func == (lhs: Country, rhs: Country) -> Bool {
        return (lhs.countryCode == rhs.countryCode && lhs.dialingCode == rhs.dialingCode)
    }
}

extension Country: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(countryCode)
        hasher.combine(countryName)
    }
}
