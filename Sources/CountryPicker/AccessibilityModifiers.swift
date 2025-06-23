//
//  AccessibilityModifiers.swift
//  CountryPicker
//
//  Created by Accessibility Implementation
//

import SwiftUI

public struct AccessibilityConfiguration {
    public let enableVoiceOverAnnouncements: Bool
    
    public init(
        enableVoiceOverAnnouncements: Bool = true
    ) {
        self.enableVoiceOverAnnouncements = enableVoiceOverAnnouncements
    }
} 
