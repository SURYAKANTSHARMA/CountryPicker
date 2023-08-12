//
//  File.swift
//  
//
//  Created by ANKUSH BHATIA on 8/2/23.
//

import Foundation

final class CountryPickerWheelViewModel: ObservableObject {
    
    let countries: [Country]
    @Published var selected: Int
    
    init(countries: [Country], selected: Int) {
        self.countries = countries
        self.selected = selected
    }
}
