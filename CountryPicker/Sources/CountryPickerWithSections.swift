//
//  SwiftUIView.swift
//  
//
//  Created by Surya on 27/05/23.
//

import SwiftUI
import UIKit // For UIAccessibility

public
struct CountryPickerWithSections: View {
    
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var viewModel: CountryPickerWithSectionViewModel
    @State var searchText: String
    @State private var searchWorkItem: DispatchWorkItem?
    @Binding private var selectedCountry: Country

    let configuration: Configuration

    public init(
         configuration: Configuration = Configuration(),
         searchText: String = "",
         selectedCountry: Binding<Country>) {
         self.configuration = configuration
         _searchText = State(initialValue: searchText)
        _selectedCountry = selectedCountry
        viewModel = .init(selectedCountry: selectedCountry.wrappedValue)
    }

    public var body: some View {
        NavigationView {
            ScrollViewReader { scrollView in
                ZStack {
                    List {
                        ForEach(viewModel.sections) { section in
                            SwiftUI.Section {
                                
                                ForEach(section.countries) { country in
                                    CountryCell(country: country,
                                                isSelected: selectedCountry == country,
                                                configuration: configuration,
                                                selectedCountry: $viewModel.selectedCountry)
                                }
                            } header: {
                                if let sectionTitle = section.title {
                                    Text(sectionTitle)
                                        .font(.headline) // Ensure dynamic type support
                                        .accessibilityAddTraits(.isHeader)
                                }
                            }
                        }
                    }
                    
                    SectionIndexView(
                        titles: viewModel
                            .sections
                            .compactMap { $0.title }) {
                        scrollView.scrollTo($0)
                    }
                }
                .onChange(of: searchText) { _ in // Use _ if newValue is not directly used, searchText state var is used instead
                    searchWorkItem?.cancel()

                    let workItem = DispatchWorkItem {
                        // Perform filtering using the current value of searchText
                        viewModel.filterWithText(searchText)

                        // Make announcement
                        if configuration.accessibility.announceSearchResults && !searchText.isEmpty {
                            // Calculate count from viewModel.sections
                            let count = viewModel.sections.reduce(0) { $0 + $1.countries.count }
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
                .onChange(of: viewModel.selectedCountry) {
                   selectedCountry = $0
                   presentationMode.wrappedValue.dismiss()
                }
                
                .onDisappear {
                    viewModel.setLastSelectedCountry()
                    viewModel.reset()
                }
                .listStyle(.grouped)
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
        }
        .searchable(text: $searchText)
    }
}


struct CountryPickerWithSections_Previews: PreviewProvider {
    static var previews: some View {
        CountryPickerWithSections(
            configuration: Configuration(),
            searchText: "",
            selectedCountry: .constant(Country(countryCode: "IN"))
        )
    }
}

struct SectionIndexView: View {
    let titles: [String]
    let onClick: (String)->Void
    
    var body: some View {
        VStack {
            ForEach(titles, id: \.self) { title in
                HStack {
                    Spacer()
                        Button(action: {
                            withAnimation {
                                onClick(title)
                            }
                        }, label: {
                            Text(title)
                                .font(.system(size: 12))
                                .padding(.trailing, 7)
                        })
                        .accessibilityLabel({
                            let format = NSLocalizedString("ACC_LABEL_SECTION_INDEX", bundle: AccessibilityUtil.pickerAccessibilityBundle, comment: "Accessibility label for section index button")
                            return String(format: format, title)
                        }())
                }
            }
        }
    }
}
