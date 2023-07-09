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
        
//        defer {
//            sections = mapper.mapIntoSection()
//        }
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
        let sut = CountryPickerWithSectionViewModel(
            dataService: mockService,
            mapper: SectionMapper())
    
//        XCTAssertEqual(sut.sections, ["": []])
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

