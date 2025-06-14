//
//  SwiftUIView.swift
//  
//
//  Created by Surya on 20/05/23.
//

import SwiftUI
import Combine
import UIKit // For UIAccessibility

public
enum CountryFlagStyle {
    case corner
    case circular
    case normal
}

public
struct CountryPickerView: View {
    
    @Environment(\.presentationMode) var presentationMode

    @State private var filterCountries = [Country]()
    @State private var applySearch = false
    @State private var searchText = ""
    @State private var searchWorkItem: DispatchWorkItem?
    @Binding private var selectedCountry: Country
    
    let configuration: Configuration
    let manager: any CountryListDataSource

    private var searchResults: [Country] {
        searchText.isEmpty ? manager.allCountries([]) : filterCountries
    }

    public
    init(manager: any CountryListDataSource = CountryManager.shared,
         configuration: Configuration = Configuration(),
         selectedCountry: Binding<Country>) {
        self.manager = manager
        self.configuration = configuration
        self._selectedCountry = selectedCountry
    }

    public var body: some View {
        NavigationView {
            List(searchResults) { country in
                CountryCell(country: country,
                            isSelected: selectedCountry == country,
                            configuration: configuration,
                            selectedCountry: $selectedCountry)
            }.listStyle(.grouped)
            .searchable(text: $searchText)
            .navigationTitle(configuration.navigationTitleText)
            .onChange(of: searchText) { _ in // Use _ if newValue is not directly used, searchText state var is used instead
                searchWorkItem?.cancel()

                let workItem = DispatchWorkItem {
                    // Perform filtering using the current value of searchText
                    filterCountries = manager.filterCountries(searchText: searchText)

                    // Make announcement
                    if configuration.accessibility.announceSearchResults && !searchText.isEmpty {
                        // searchResults computed property will use the updated filterCountries
                        let count = searchResults.count
                        let announcementString: String
                        if count > 0 {
                            let format = NSLocalizedString("ACC_ANNOUNCE_SEARCH_RESULTS_FOUND", bundle: AccessibilityUtil.pickerAccessibilityBundle, comment: "Announcement for search results found")
                            announcementString = String(format: format, count)
                        } else {
                            let format = NSLocalizedString("ACC_ANNOUNCE_SEARCH_RESULTS_NOT_FOUND", bundle: AccessibilityUtil.pickerAccessibilityBundle, comment: "Announcement for no search results found")
                            announcementString = String(format: format, searchText)
                        }
                        UIAccessibility.post(notification: .announcement, argument: announcementString)
                    }
                }
                searchWorkItem = workItem
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: workItem)
            }
            .onDisappear {
                manager.lastCountrySelected = selectedCountry
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .font(.callout)
                        }
                    }
            }
        }
        .onChange(of: selectedCountry) { _ in
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct CountryCell: View {
    
    let country: Country
    let isSelected: Bool
    let configuration: Configuration
    
    @Binding var selectedCountry: Country
    
    var body: some View {
        Button {
            selectedCountry = country
        } label: {
            HStack {
                let image = Image(uiImage: country.flag ?? .init())
                    .resizable()

                if !configuration.isCountryFlagHidden {
                    switch configuration.flagStyle {
                    case .normal:
                           image
                            .frame(width: 40, height: 26)
                            .scaledToFit()
                    case .circular:
                        image
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())

                    case .corner:
                        image.frame(width: 40, height: 26)
                            .scaledToFit()
                            .cornerRadius(8)
                    }
                }
                VStack(alignment: .leading) {
                    Text(country.countryName)
                        .font(.body) // Changed from configuration.labelFont
                        .foregroundColor(configuration.labelColor)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)

                    if !configuration.isCountryDialHidden {
                        Text(country.dialingCode ?? "")
                            .font(.caption1) // Changed from configuration.detailFont
                            .foregroundColor(configuration.detailColor)
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                    }
                }

                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel({
            var labelParts: [String] = []
            labelParts.append(country.countryName)

            if !configuration.isCountryFlagHidden {
                switch configuration.accessibility.flagDescriptionStyle {
                case .country:
                    labelParts.append(String(format: NSLocalizedString("ACC_LABEL_FLAG_SUFFIX_COUNTRY", bundle: AccessibilityUtil.pickerAccessibilityBundle, comment: "Flag description: country name"), country.countryName))
                case .emoji:
                    labelParts.append(NSLocalizedString("ACC_LABEL_FLAG_SUFFIX_EMOJI", bundle: AccessibilityUtil.pickerAccessibilityBundle, comment: "Flag description: emoji"))
                case .none:
                    break
                }
            }

            if !configuration.isCountryDialHidden, let dialCode = country.dialingCode, !dialCode.isEmpty {
                labelParts.append(String(format: NSLocalizedString("ACC_LABEL_DIAL_CODE_SUFFIX", bundle: AccessibilityUtil.pickerAccessibilityBundle, comment: "Dial code description"), dialCode))
            }

            // The subtask asks for .accessibilityLabel(fullLabel), which expects a String.
            // However, the previous implementation returned Text(fullLabel) from the closure.
            // For consistency with SwiftUI's .accessibilityLabel(_ text: Text) modifier when using a closure,
            // we will return Text. If a direct String was required, the modifier would be .accessibilityLabel(fullLabelString).
            return Text(labelParts.joined(separator: ", "))
        }())
        .accessibilityHint({
            let hintFormat = NSLocalizedString("ACC_HINT_DOUBLE_TAP_SELECT", bundle: AccessibilityUtil.pickerAccessibilityBundle, comment: "Accessibility hint for selecting a country")
            // Similar to label, hint can also take a Text view directly from a closure.
            return Text(String(format: hintFormat, country.countryName))
        }())
        .accessibilityAddTraits(.isButton)
        .accessibilityAction(named: Text(NSLocalizedString("ACC_ACTION_COPY_DIAL_CODE", bundle: AccessibilityUtil.pickerAccessibilityBundle, comment: "Accessibility action: Copy dial code"))) {
            if configuration.accessibility.enableCustomActions {
                if let dialCode = country.dialingCode, !dialCode.isEmpty {
                    UIPasteboard.general.string = dialCode
                }
            }
        }
        .accessibilityAction(named: Text(NSLocalizedString("ACC_ACTION_SELECT_AND_DISMISS", bundle: AccessibilityUtil.pickerAccessibilityBundle, comment: "Accessibility action: Select and dismiss"))) {
            if configuration.accessibility.enableCustomActions {
                selectedCountry = country
            }
        }
    }
}

struct CountryPickerView_Previews: PreviewProvider {
    static var previews: some View {
        CountryPickerView(
            configuration: Configuration(),
            selectedCountry: .constant(Country(countryCode: "IN")))
    }
}

