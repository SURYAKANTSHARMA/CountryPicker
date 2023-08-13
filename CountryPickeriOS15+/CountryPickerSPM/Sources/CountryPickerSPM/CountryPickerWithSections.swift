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

    @ObservedObject var viewModel: CountryPickerWithSectionViewModel = .default
    @State var searchText: String
    @Binding private var selectedCountry: Country?

    let configuration: Configuration

    public init(
         configuration: Configuration = Configuration(),
         searchText: String = "",
         selectedCountry: Binding<Optional<Country>>) {
         self.configuration = configuration
         _searchText = State(initialValue: searchText)
        _selectedCountry = selectedCountry
        viewModel.selectedCountry = selectedCountry.wrappedValue
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
                .onChange(of: searchText) {
                    viewModel.filterWithText($0)
                }
                .onChange(of: viewModel.selectedCountry) { newValue in
                    if newValue != nil {
                        selectedCountry = newValue
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                .onDisappear {
                    viewModel.setLastSelectedCountry()
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
            selectedCountry: .constant(.none)
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
                }
            }
        }
    }
}
