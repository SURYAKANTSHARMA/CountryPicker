//
//  SwiftUIView.swift
//  
//
//  Created by Surya on 27/05/23.
//

import SwiftUI
public
struct CountryPickerWithSections: View {
    
    @StateObject var viewModel: CountryPickerWithSectionViewModel = .default
    let configuration: Configuration
    @State var searchText: String
    
    public init(configuration: Configuration,
         searchText: String = "") {
        self.configuration = configuration
         _searchText = State(initialValue: searchText)
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
                                                isFavorite: false,
                                                selectedCountry: $viewModel.selectedCountry,
                                                configuration: configuration)
                                    .onTapGesture {
                                        viewModel.selectedCountry = country
                                    }
                                }
                            } header: {
                                if let sectionTitle = section.title {
                                    Text(sectionTitle)
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
                .listStyle(.grouped)
            }
        }
        .searchable(text: $searchText)
    }
}


struct CountryPickerWithSections_Previews: PreviewProvider {
    static var previews: some View {
        CountryPickerWithSections(
            configuration: Configuration(), searchText: ""
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
                    //need to figure out if there is a name in this section before I allow scrollto or it will crash
                        Button(action: {
                            withAnimation {
                                onClick(title)
                            }
                        }, label: {
                            Text(title)
                                .font(.system(size: 12))
                                .padding(.trailing, 7)
                        })
                }
            }
        }
    }
}
