//
//  File.swift
//  
//
//  Created by Surya on 29/07/23.
//

import Foundation
import SwiftUI

public
struct Configuration {
    
    public let flagStyle: CountryFlagStyle
    public let labelFont: Font
    public let labelColor: Color
    public let detailFont: Font
    public let detailColor: Color
    public let isCountryFlagHidden: Bool
    public let isCountryDialHidden: Bool
    public let navigationTitleText: String
    
    public init(
        flagStyle: CountryFlagStyle = CountryFlagStyle.corner,
        labelFont: Font = .title2,
        labelColor: Color = .primary,
        detailFont: Font = .footnote,
        detailColor: Color = .secondary,
        isCountryFlagHidden: Bool = false,
        isCountryDialHidden: Bool = false,
        navigationTitleText: String = "CountryPicker"
    ) {
        self.flagStyle = flagStyle
        self.labelFont = labelFont
        self.labelColor = labelColor
        self.detailFont = detailFont
        self.detailColor = detailColor
        self.isCountryFlagHidden = isCountryFlagHidden
        self.isCountryDialHidden = isCountryDialHidden
        self.navigationTitleText = navigationTitleText
    }
}
