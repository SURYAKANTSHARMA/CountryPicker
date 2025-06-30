//
//  SwiftUIView.swift
//  
//
//  Created by Surya on 27/05/23.
//

import SwiftUI
public
struct CountryPickerWithSections: View {
    
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var viewModel: CountryPickerWithSectionViewModel
    @State var searchText: String
    @Binding private var selectedCountry: Country?

    let configuration: Configuration

    public init(
         configuration: Configuration = Configuration(),
         searchText: String = "",
         selectedCountry: Binding<Country?>) {
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
                                        .font(.headline)
                                        .accessibilityLabel(sectionTitle)
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
                .onChange(of: searchText) { _ in
                    viewModel.filterWithText(searchText)
                }
                .onChange(of: viewModel.selectedCountry) { newCountry in
                   selectedCountry = viewModel.selectedCountry
                   presentationMode.wrappedValue.dismiss()
                }
                .onDisappear {
                    viewModel.setLastSelectedCountry()
                    viewModel.reset()
                }
                .listStyle(.grouped)
                .searchable(text: $searchText)
                .accessibilityLabel("Country search")
                .accessibilityHint("Search for a country by name or code")
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.callout)
                        .accessibilityLabel("Close")
                        .accessibilityHint("Dismiss country picker")
                }
            }
        }
        .navigationTitle(configuration.navigationTitleText)
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
                            .accessibilityLabel("Jump to section \(title)")
                            .accessibilityHint("Double tap to jump to section \(title)")
                    })
                }
            }
        }
        .accessibilityLabel("Section Index")
        .accessibilityHint("Quick navigation to country sections")
    }
}
