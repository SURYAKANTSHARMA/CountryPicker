//
//  Enums.swift
//  SKCountryPicker
//
//  Created by Sharkes Monken on 17/08/2019.
//

import Foundation

/// Country flag styles
public enum CountryFlagStyle {
    
    // Corner style will be applied
    case corner
    
    // Circular style will be applied
    case circular
    
    // Rectangle style will be applied
    case normal
}


/// Country filtering options
public enum CountryFilterOption {
    /// Filter countries by country name
    case countryName
    
    /// Filter countries by country code
    case countryCode
    
    /// Filter countries by country dial code
    case countryDialCode
}
