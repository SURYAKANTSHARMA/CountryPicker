//
//  File.swift
//  
//
//  Created by ANKUSH BHATIA on 8/2/23.
//

import Foundation
import Combine

@MainActor final
public class CountryPickerWheelViewModel: ObservableObject {
    
    internal let countries: [Country]
    internal let dataSource: any CountryListDataSource
    
    @MainActor
    public init(dataSource: (any CountryListDataSource)? = nil) {
        let _dataSource: any CountryListDataSource  = dataSource ?? CountryManager.shared
        self.countries = _dataSource.allCountries([])
        self.dataSource = CountryManager.shared
    }
}
