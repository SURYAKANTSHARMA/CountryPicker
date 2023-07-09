import XCTest
@testable import CountryPickerSPM

class CountryPickerWithSectionViewModel: ObservableObject {
    
    @Published var sections: [Section] = []
    
    let dataService: any CountryListDataSource
    let mapper: SectionMapper
    
    internal init(dataService: any CountryListDataSource,
                  mapper: SectionMapper
    ) {
        self.dataService = dataService
        self.mapper = mapper
    }
}


final class SectionMapperTests: XCTestCase {
    
    func test_sectionmapperWhenInitWithEmptyCountries_shouldAbleToReturnEmptySectionWithGivenCountriesInAlphabeticOrder() {
        let sut = SectionMapper(countries: [
        ])
        
        XCTAssertEqual(sut.mapIntoSection(), [])
    }
    
    
    func test_sectionmapperWhenInitWithCountries_shouldAbleToReturnSectionWithGivenCountriesInAlphabeticOrder() {
        let sut = SectionMapper(countries: [
            Country(countryCode: "IN"),
            Country(countryCode: "IS"),
            Country(countryCode: "AF"),
            Country(countryCode: "US")
        ])

        let expectationOutput = [
            Section(title: "A", countries: [
                Country(countryCode: "AF"),
            ]),
            Section(title: "I", countries: [
                Country(countryCode: "IN"),
                Country(countryCode: "IS")
            ]),
            
            Section(title: "U", countries: [
                Country(countryCode: "US")
            ])
        ]

        XCTAssertEqual(sut.mapIntoSection(), expectationOutput)
    }
}

final class CountryPickerWithSectionViewModelTests: XCTestCase {
    
    func test_WhenViewModelLoadedWithAllCountries_ShouldBeAbleToReturnAllCountries() {
        let countries = [
            Country(countryCode: "IN"),
            Country(countryCode: "AF"),
            Country(countryCode: "US")
            
         ]
        let mockService = MockService(countries: countries)
        let sut = CountryPickerWithSectionViewModel(dataService: mockService,
                                                    mapper: SectionMapper(countries: countries))
    
//        XCTAssertEqual(sut.countries, ["": []])
    }
    
}


class MockService: CountryListDataSource {
    
    let countries: [Country]
    let filteredCountries: [Country]
    
    internal init(countries: [Country] = [],
                  filteredCountries:[Country] = []
    ) {
        self.countries = countries
        self.filteredCountries = filteredCountries
    }

    
    func country(withCode code: String) -> Country? {
         nil
    }
    
    func allCountries(_ favoriteCountriesLocaleIdentifiers: [String]) -> [Country] {
        countries
    }
    
    func filterCountries(searchText: String) -> [Country] {
        filteredCountries
    }
}

