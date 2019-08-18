//
//  Country.swift
//  CountryCodeInSwift3
//
//  Created by Cl-macmini-100 on 12/19/16.
//  Copyright © 2016 Suryakant. All rights reserved.
//

import Foundation
import UIKit

open class Country {

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
        return isoToDigitCountryCodeDictionary[countryCode] as? String
    }
    
    /// Image (Flag) of country
    open var flag: UIImage? {
        if image != nil {
            return image
        }
        let bundle = Bundle(for: Country.self)
        let flagImg = UIImage(named: imagePath, in: bundle, compatibleWith: nil)
        image = flagImg
        return image
    }

    var imagePath: String
    private var image: UIImage?

    // MARK: - Functions
    public init(countryCode code: String) {
        self.countryCode = code
        countryName = mapCountryName(self.countryCode)
        imagePath = "CountryPickerController.bundle/\(self.countryCode)"
    }

    func countryName(with locale: NSLocale) -> String {
        let localisedCountryName = locale.displayName(forKey: NSLocale.Key.countryCode, value: self.countryCode)!
        return localisedCountryName
    }

    func countryName(withLocaleIdentifier localeIdentifier: String) -> String {
        let locale = NSLocale(localeIdentifier: localeIdentifier)
        return self.countryName(with: locale)
    }
}

func mapCountryName(_ countryCode: String) -> String {
    let locale = NSLocale(localeIdentifier: NSLocale.preferredLanguages[0])
    let localisedCountryName = locale.displayName(forKey: NSLocale.Key.countryCode, value: countryCode)!
    return localisedCountryName
}
