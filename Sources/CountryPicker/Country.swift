//
//  Country.swift
//  CountryCodeInSwift3
//
//  Created by Cl-macmini-100 on 12/19/16.
//  Copyright © 2016 Suryakant. All rights reserved.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

@MainActor
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
            let message = "Failed to localised country name for Country Code:- \(self.countryCode)"
#if DEBUG
            print(message)
#endif
            return ""
        }
        return localisedCountryName
    }

    func countryName(withLocaleIdentifier localeIdentifier: String) -> String {
        let locale = Locale(identifier: localeIdentifier)
        return self.countryName(with: locale)
    }
    
    static func mapCountryName(_ countryCode: String) -> String {
        let locale = Locale(identifier: Locale.preferredLanguages.first!)
        guard let localisedCountryName = locale.localizedString(forRegionCode: countryCode) else {
            let message = "Failed to localised country name for Country Code:- \(countryCode)"
#if DEBUG
            print(message)
#endif
            
            return ""
        }
        return localisedCountryName
    }

}

extension Country: @preconcurrency Equatable {
     public static func == (lhs: Country, rhs: Country) -> Bool {
        return (lhs.countryCode == rhs.countryCode && lhs.dialingCode == rhs.dialingCode)
    }
}

@MainActor
extension Country: @preconcurrency Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(countryCode)
        hasher.combine(countryName)
    }
}
