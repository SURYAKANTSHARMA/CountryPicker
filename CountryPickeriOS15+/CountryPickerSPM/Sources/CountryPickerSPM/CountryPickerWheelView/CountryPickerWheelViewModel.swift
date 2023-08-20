//
//  File.swift
//  
//
//  Created by ANKUSH BHATIA on 8/2/23.
//

import Foundation
import Combine

final
public class CountryPickerWheelViewModel: ObservableObject {
    
    internal let countries: [Country]
    private var anyCancellable: AnyCancellable?
    private let dataSource: any CountryListDataSource
    
    @Published var selected: Int

    public init(dataSource: any CountryListDataSource = CountryManager.shared,
         currentCountry: Country? = CountryManager.shared.preferredCountry) {
        self.countries = dataSource.allCountries([])
        self.selected = dataSource.allCountries([])
            .firstIndex( where: { $0 == currentCountry }) ?? 0
        self.dataSource = dataSource
        anyCancellable = self.$selected
            .sink { [weak self] in
                self?.dataSource.lastCountrySelected = self?.countries[$0]
            }
    }
    
}
