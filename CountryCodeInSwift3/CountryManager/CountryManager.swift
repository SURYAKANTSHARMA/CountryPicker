//
//  CountryManager.swift
//  CountryCodeInSwift3
//
//  Created by Cl-macmini-100 on 12/19/16.
//  Copyright © 2016 Suryakant. All rights reserved.
//

import Foundation
import UIKit

class CountryManager {
  
  //MARK:- variable
  private(set) var countriesArray = [Country]()
  static var  shared : CountryManager = {
    //intancitaed wheneEver neened
    let countryManager = CountryManager()
    countryManager.loadCountries()
    return countryManager
  }()
  
  open var lastCountrySelected: Country?
  
  private init() {
  }
  
  func loadCountries() {
      let methodStart = Date()
      let bundle = Bundle(for: type(of: self))
      if let countriesPath = bundle.path(forResource: "CountryPickerController.bundle/countries", ofType: "plist"){
        if let  _array = (NSArray(contentsOfFile: countriesPath) as? [String]){
          self.countriesArray.removeAll()
          for item in _array{
            let country = Country(countryCode: item)
            self.countriesArray.append(country)
          }
          self.countriesArray = self.countriesArray.sorted(by:{
            $0.countryName < $1.countryName
          })
         
          let methodFinish = Date()
          let executionTime = methodFinish.timeIntervalSince(methodStart)
          print("Execution time: \(executionTime)")
          //Hide your activity indicator here
        } else {
          print("Add array of countries plist in your project")
          return
        }
      }else {
        print("Countries could not be loaded from plist , please check path")
      }
    
  }
  /**
   return all countries in plist.
   - returns: array of countries
   */
  func allCountries() -> [Country] {
    return countriesArray
  }
  /**
   Give the current country instance.
   - returns: A country instance.
   */
  
  // MARK: - Public functions
  class func country(with code: String) -> Country {
    return Country(countryCode: code)
  }
  
  class var currentCountry: Country? {
    if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
      let country = Country(countryCode: countryCode)
      return country
    }
    return nil
  }
 }
