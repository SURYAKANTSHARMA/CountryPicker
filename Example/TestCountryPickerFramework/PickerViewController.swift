//
//  PickerViewController.swift
//  TestCountryPickerFramework
//
//  Created by Hardeep Singh on 05/12/19.
//  Copyright © 2019 SuryaKant Sharma. All rights reserved.
//

import UIKit
import SKCountryPicker

class PickerViewController: UIViewController {

    @IBOutlet weak var storyboardPickerView: CountryPickerView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var storyboardLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Show country picker view on tap TextField.
        setupPickerViewForTextField()
        
        // Configure picker with help of storyboard.
        setupStoryboardPickerViewCallback()
        
    }
    
    private func setupPickerViewForTextField() {
        
        let picketView = CountryPickerView.loadPickerView { [weak self] (country) in
            
            guard let weakSelf = self,
                let digitCountrycode = country.digitCountrycode else {
                return
            }
            
            let text = "\(digitCountrycode) \(country.countryCode)"
            weakSelf.textField.text = text
        
            print("SELECTED Country\n\(country.countryName)")
            print("\(String(describing: country.dialingCode))")
            print("\(country.countryCode)")
            print("\(String(describing: country.digitCountrycode))")
            
        }
        
        // Set pick list menually.
        picketView.setPickList(codes: "AQ", "IL", "AF", "AL", "DZ", "IN")
        
        textField.inputView = picketView
    }
    
    private func setupStoryboardPickerViewCallback() {
        storyboardPickerView.onSelectCountry { [weak self] (country) in
            
            guard let weakSelf = self,
                let digitCountrycode = country.digitCountrycode else {
                return
            }
            
            let text = "\(digitCountrycode) \(country.countryCode)"
            weakSelf.storyboardLabel.text = text
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textField.resignFirstResponder()
    }
    
}
