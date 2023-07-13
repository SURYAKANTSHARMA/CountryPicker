//
//  SwiftUIView.swift
//  
//
//  Created by Surya on 27/05/23.
//

import SwiftUI
public
struct CountryPickerWithSections: View {

    @StateObject var viewModel: CountryPickerWithSectionViewModel
    let configuration: Configuration
    @State var searchText: String
    
    public var body: some View {
        NavigationView {
            ScrollViewReader { scrollView in
                List {
                    ForEach(viewModel.sections) { section in
                        ForEach(section.countries) { country in
                            CountryCell(country: country,
                                        isFavorite: false,
                                        selectedCountry: $viewModel.selectedCountry,
                                        configuration: configuration)
                            .onTapGesture {
                                viewModel.selectedCountry = country
                            }
                        }
                    }
                }
                .searchable(text: $searchText)
                .navigationTitle("Country Picker")
                .onChange(of: searchText) {
                    viewModel.filterWithText($0)
                }
                .onDisappear {
                    viewModel.setLastSelectedCountry()
                    
                }
                .onAppear {
                    // Scroll to the selected country when appearing
                    if let selectedCountry = viewModel.selectedCountry {
                        withAnimation {
                            scrollView.scrollTo(selectedCountry.countryName, anchor: .top)
                        }
                    }
                }
                .listStyle(GroupedListStyle())
            }
        }
    }
}


struct CountryPickerWithSections_Previews: PreviewProvider {
    static var previews: some View {
        CountryPickerWithSections(
            viewModel: CountryPickerWithSectionViewModel(
                dataService: CountryManager.shared,
                favoriteCountriesLocaleIdentifiers: ["IN"],
                mapper: SectionMapper(favoriteCountriesLocaleIdentifiers: ["IN"])),
            configuration: Configuration(), searchText: ""
        )
    }
}
