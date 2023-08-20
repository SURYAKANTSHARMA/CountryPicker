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
    internal let dataSource: any CountryListDataSource
    
    public init(dataSource: any CountryListDataSource = CountryManager.shared) {
        self.countries = dataSource.allCountries([])
        self.dataSource = dataSource
    }
}
