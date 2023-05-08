//
//  CountryPickerViewProxy.swift
//  CountryPickerSwiftUIExample
//
//  Created by Suryakant Sharma on 25/07/22.
//

import UIKit
import SwiftUI
import CountryPicker

struct CountryPickerViewProxy: UIViewControllerRepresentable {
    
    let onSelect: (( _ chosenCountry: Country) -> Void)?
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        
    }
    
    func makeUIViewController(context: Context) -> UINavigationController {
        UINavigationController(rootViewController: CountryPickerController.create {
            onSelect?($0)}
        )
    }
}
