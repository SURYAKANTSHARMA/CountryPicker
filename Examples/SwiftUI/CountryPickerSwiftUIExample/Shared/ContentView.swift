//
//  ContentView.swift
//  Shared
//
//  Created by Suryakant on 04/01/22.
//

import SwiftUI
import CountryPicker

struct ContentView: View {
    @State private var isShowCountryPicker = false
    
    var body: some View {
        Button("Select Country") {
            isShowCountryPicker = true
        }.sheet(isPresented: $isShowCountryPicker) {
            CountryPickerAdapter()
        }
    }
    
    func openCountryPicker() {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct CountryPickerAdapter: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: CountryPickerWithSectionViewController, context: Context) {
        
    }
    
    func makeUIViewController(context: Context) -> CountryPickerWithSectionViewController {
        CountryPickerWithSectionViewController()
    }
        
    typealias UIViewControllerType = CountryPickerWithSectionViewController
    
    
}
