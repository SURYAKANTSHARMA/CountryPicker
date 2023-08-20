import XCTest
import Combine

@testable import CountryPickerSPM



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
        
        let sut = makeSUT(countries: countries, mockService: mockService)

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
    
    func test_WhenViewModelFilterWithEmpty_shouldReturnSectionWithAllCountries() {
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
        
        let sut = makeSUT(countries: countries, mockService: mockService)
        
        sut.filterWithText("")
        
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
    
    func test_withFavouriteCountryGiven_sectionShouldReturnItInIndex0AndWithoutSectionTitle() {
        let favoriteCountriesLocaleIdentifiers = ["IN"]
        
        let countries = [
            Country(countryCode: "IN"),
            Country(countryCode: "AF"),
            Country(countryCode: "US"),
            Country(countryCode: "IS")
        ]

        let mockService = MockService(countries: countries)

        let sut = makeSUT(countries: countries,
                          mockService: mockService,
                          favoriteCountriesLocaleIdentifiers: favoriteCountriesLocaleIdentifiers)


        let expectationOutput = [
            Section(title: nil,
                    countries: [
                        Country(countryCode: "IN")
                    ]),
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

    func test_withFavouriteCountryGiven_whenSearchWithEmptyTextAfterTypingSomething_sectionShouldReturnAllCountriesWithFavouriteCountry() {
        let countries = [
            Country(countryCode: "IN"),
            Country(countryCode: "AF"),
            Country(countryCode: "US"),
            Country(countryCode: "IS")
        ]

        let sut = makeSUT(countries: countries,
                          favoriteCountriesLocaleIdentifiers: ["IN"])

        sut.filterWithText("abc")
        sut.filterWithText("")

        let expectationOutput = [
            Section(title: nil,
                    countries: [
                        Country(countryCode: "IN")
                    ]),
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
    
    // MARK: - SUT private function
    private func makeSUT(countries: [Country] = [],
                         favoriteCountriesLocaleIdentifiers: [String] = [])
       -> CountryPickerWithSectionViewModel {
        let mockService = MockService(countries: countries)
        let sut = CountryPickerWithSectionViewModel(
            dataService: mockService,
            mapper: SectionMapper(favoriteCountriesLocaleIdentifiers: favoriteCountriesLocaleIdentifiers), selectedCountry: Country(countryCode: "IN"))
        
        return sut
    }
    
    
    private func makeSUT(countries: [Country] = [],
                         mockService: MockService,
                         favoriteCountriesLocaleIdentifiers: [String] = [])
       -> CountryPickerWithSectionViewModel {
        let sut = CountryPickerWithSectionViewModel(
            dataService: mockService,
            mapper: SectionMapper(favoriteCountriesLocaleIdentifiers: favoriteCountriesLocaleIdentifiers), selectedCountry: Country(countryCode: "IN"))
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

