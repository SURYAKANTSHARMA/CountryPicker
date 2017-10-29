//
//  Country.swift
//  CountryCodeInSwift3
//
//  Created by Cl-macmini-100 on 12/19/16.
//  Copyright © 2016 Suryakant. All rights reserved.
//

import Foundation
import UIKit

class Country {
  
  //MARK:- Variable
  var countryCode: String
  var countryName: String
  var imagePath: String
  
  private var image: UIImage? = nil;
  /// flag for country given
  var flag: UIImage? {
    if image != nil {
      return image;
    }
    let flagImg = UIImage(named: imagePath, in: nil, compatibleWith: nil)
    image  = flagImg
    return image
  }
  
  //MARK:- Functions
  init(countryCode code: String) {
    
    self.countryCode = code
    countryName = mapCountryName(self.countryCode)
    imagePath = "CountryPickerController.bundle/\(self.countryCode)"
   
  }
  
  func countryName(with locale: NSLocale) -> String {
    let localisedCountryName = locale.displayName(forKey: NSLocale.Key.countryCode, value: self.countryCode)!
    return localisedCountryName
  }
  
  ///Return dialing code for country instance
  func dialingCode() -> String? {
    if let digitCountryCode = isoToDigitCountryCodeDictionary[countryCode] as? String {
      return "+" + digitCountryCode
    }
    print("Please check your Constant file it not contain key for \(countryCode) with countryName: \(countryName)")
    return nil
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


