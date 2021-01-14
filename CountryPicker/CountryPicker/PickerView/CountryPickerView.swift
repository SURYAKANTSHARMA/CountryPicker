//
//  CountryPickerView.swift
//  CountryPicker
//
//  Created by Hardeep Singh on 05/12/19.
//  Copyright © 2019 SuryaKant Sharma. All rights reserved.
//

import UIKit

open class CountryPickerView: UIPickerView {
    
    private var selectedCountry: Country?
    private let rowHeight: CGFloat = 45.0
    // ISO 3166-1 alpha-2 two-letter country codes.
    private var countryCodes: [String] = [String]() {
        didSet {
            self.updatePickList()
        }
    }
    
    private var allCountryList: [Country] = [Country]()
    
    private var didSelectCountryCallback: ((_ country: Country) -> Void)?
    
    private(set) var pickList: [Country] = [Country]() {
        didSet {
            self.reloadComponent(0)
        }
    }
    
    private func updatePickList() {
        var tempList = countryCodes
        let list = allCountryList.filter { (country) -> Bool in
            if let index = tempList.firstIndex(of: country.countryCode) {
                tempList.remove(at: index)
                return true
            }
            return false
        }
        self.pickList = list
    }
     
    init(allCountryList: [Country], selectedCountry: Country? = nil) {
        super.init(frame: CGRect.zero)
        self.allCountryList = allCountryList
        self.selectedCountry = selectedCountry
        self.configure()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.allCountryList = CountryManager.shared.countries
        self.selectedCountry = CountryManager.shared.currentCountry
        configure()
    }
    
    
    public func onSelectCountry(callback: @escaping (_ country: Country) -> Void) {
        self.didSelectCountryCallback = callback
    }
    
    private func configure() {
        self.pickList = allCountryList
        
        self.delegate = self
        self.dataSource = self
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.scrollToSelectedCountry()
    }
    
    // MARK: - Public API
    private func scrollToSelectedCountry() {
        guard let selectedCountry = selectedCountry else {
            return
        }
        if let index =  allCountryList.firstIndex(where: { $0 == selectedCountry }) {
            self.selectRow(index, inComponent: 0, animated: false)
        }
    }

    // ISO 3166-1 alpha-2 two-letter country codes.
    public func setPickList(codes: String...) {
        self.countryCodes = codes
    }
    
    public static func loadPickerView(allCountryList: [Country] = CountryManager.shared.countries, selectedCountry: Country? = CountryManager.shared.currentCountry, didSelectCountry: @escaping (_ country: Country) -> Void) -> CountryPickerView {
        let countryPicker = CountryPickerView(allCountryList: allCountryList, selectedCountry: selectedCountry)
        countryPicker.didSelectCountryCallback = didSelectCountry
        return countryPicker
    }
}

// MARK: UIPickerViewDataSource methods
extension CountryPickerView: UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickList.count
    }

}

// MARK: UIPickerViewDelegate methods
extension CountryPickerView: UIPickerViewDelegate {
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int,
                           forComponent component: Int, reusing view: UIView?) -> UIView {
        var reuseableView = view as? ComponentView
        if reuseableView == nil {
            let rect = CGRect(x: 0, y: 0, width: 200, height: 40.0)
            reuseableView = ComponentView(frame: rect)
        }
        
        let country = pickList[row]
        reuseableView?.imageView.image = country.flag
        reuseableView?.countryNameLabel.text = country.countryName
        reuseableView?.diallingCodeLabel.text = country.dialingCode
        
        return reuseableView!
    }
    
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return rowHeight
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let country = pickList[row]
        didSelectCountryCallback?(country)
    }
}
