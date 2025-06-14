//
//  File.swift
//  
//
//  Created by Surya on 29/07/23.
//

import Foundation
import SwiftUI

public struct CountryPickerAccessibilityConfiguration {
    public var announceCountryChanges: Bool = true
    public var useDetailedLabels: Bool = true
    public var enableCustomActions: Bool = true
    public var announceSearchResults: Bool = true
    public var flagDescriptionStyle: FlagDescriptionStyle = .country

    public enum FlagDescriptionStyle {
        case country, emoji, none
    }

    public init(
        announceCountryChanges: Bool = true,
        useDetailedLabels: Bool = true,
        enableCustomActions: Bool = true,
        announceSearchResults: Bool = true,
        flagDescriptionStyle: FlagDescriptionStyle = .country
    ) {
        self.announceCountryChanges = announceCountryChanges
        self.useDetailedLabels = useDetailedLabels
        self.enableCustomActions = enableCustomActions
        self.announceSearchResults = announceSearchResults
        self.flagDescriptionStyle = flagDescriptionStyle
    }
}

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
    public let accessibility: CountryPickerAccessibilityConfiguration
    
    public init(
        flagStyle: CountryFlagStyle = CountryFlagStyle.corner,
        labelFont: Font = .title2,
        labelColor: Color = .primary,
        detailFont: Font = .footnote,
        detailColor: Color = .secondary,
        isCountryFlagHidden: Bool = false,
        isCountryDialHidden: Bool = false,
        navigationTitleText: String = "Country Picker",
        accessibility: CountryPickerAccessibilityConfiguration = CountryPickerAccessibilityConfiguration()
    ) {
        self.flagStyle = flagStyle
        self.labelFont = labelFont
        self.labelColor = labelColor
        self.detailFont = detailFont
        self.detailColor = detailColor
        self.isCountryFlagHidden = isCountryFlagHidden
        self.isCountryDialHidden = isCountryDialHidden
        self.navigationTitleText = navigationTitleText
        self.accessibility = accessibility
    }
}
