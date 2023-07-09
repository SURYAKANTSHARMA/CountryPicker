import XCTest
import Combine

@testable import CountryPickerSPM

class CountryPickerWithSectionViewModel: ObservableObject {
    
    @Published var sections: [Section] = []
    
    let dataService: any CountryListDataSource
    private let mapper: SectionMapper
    
    internal init(dataService: any CountryListDataSource,
                  mapper: SectionMapper
    ) {
        self.dataService = dataService
        self.mapper = mapper
        
        defer {
            sections = mapper.mapIntoSection(countries: dataService.allCountries([]))
        }
    }
    
    func filterWithText(_ text: String) {
        let filteredCountries = dataService.filterCountries(searchText: text)
        sections = mapper.mapIntoSection(countries: filteredCountries)
    }
}



final class CountryPickerWithSectionViewModelTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    
    func test_WhenViewModelLoadedWithEmptyCountries_ShouldBeAbleToReturnEmptySection() {
        let sut = makeSUT()
        let expectationOutput: [Section] = [
        ]

        XCTAssertEqual(sut.sections, expectationOutput)
    }
    
    func test_WhenViewModelLoadedWithSomeCountries_shouldReturnSectionAccordingly() {
        let countries = [
            Country(countryCode: "IN"),
            Country(countryCode: "AF"),
            Country(countryCode: "US"),
            Country(countryCode: "IS")
         ]
        
        let sut = makeSUT(countries: countries)
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

        XCTAssertEqual(sut.sections, expectationOutput)

    }
    
    
    func test_WhenViewModelFilterWithText_shouldReturnSectionWithRelaventCountries() {
        let countries = [
            Country(countryCode: "IN"),
            Country(countryCode: "AF"),
            Country(countryCode: "US"),
            Country(countryCode: "IS")
        ]
        
        let mockService = MockService(countries: countries,
                                      filteredCountries: [
            Country(countryCode: "IN"),
            Country(countryCode: "IS")
        ])
        let sut = CountryPickerWithSectionViewModel(
            dataService: mockService,
            mapper: SectionMapper())
        
        let expectation = expectation(description: "Section should publish correct value")
        
        let expectationOutput = [
            Section(title: "I", countries: [
                Country(countryCode: "IN"),
                Country(countryCode: "IS")
            ]),
        ]
        
        sut.$sections
            .dropFirst()
            .sink { value  in
                XCTAssertEqual(value, expectationOutput)
                expectation.fulfill()
            }.store(in: &cancellables)

        sut.filterWithText("I")
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    private func makeSUT(countries: [Country] = [])
       -> CountryPickerWithSectionViewModel {
        let mockService = MockService(countries: countries)
        let sut = CountryPickerWithSectionViewModel(
            dataService: mockService,
            mapper: SectionMapper())
        
        return sut
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

