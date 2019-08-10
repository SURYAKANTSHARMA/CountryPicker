//
//  ViewController.swift
//  TestCountryPickerFramework
//
//  Created by SuryaKant Sharma on 11/03/18.
//  Copyright © 2018 SuryaKant Sharma. All rights reserved.
//

import UIKit
import SKCountryPicker

class ViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var countryCodeButton: UIButton!
    @IBOutlet weak var countryImageView: UIImageView!
    let contryPickerController = CountryPickerController()

    @IBOutlet weak var showDialingCodeSwitch: UISwitch!
    @IBOutlet weak var showWithSectionsSwitch: UISwitch!
    @IBOutlet weak var showCountryFlagSwitch: UISwitch!
    // MARK: - Func
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.addAccessibilityLabel()
        
        guard let country = CountryManager.shared.currentCountry else {
            self.countryCodeButton.setTitle("Pick Country", for: .normal)
            self.countryImageView.isHidden = true
            return
        }
        
        countryCodeButton.setTitle(country.dialingCode, for: .normal)
        countryImageView.image = country.flag
        countryCodeButton.clipsToBounds = true
        countryCodeButton.accessibilityLabel = Accessibility.selectCountryPicker
    }
    
    private func addAccessibilityLabel() {
        showWithSectionsSwitch.accessibilityLabel = "show countries with section"
        showCountryFlagSwitch.accessibilityLabel = "show countries with section"
        showDialingCodeSwitch.accessibilityLabel = "show countries with section"
    }
    
    @IBAction func countryCodeButtonClicked(_ sender: UIButton) {
        switch showWithSectionsSwitch.isOn {
        case true:
            let countryController = CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in
                
                guard let self = self else { return }
                
                self.countryImageView.isHidden = false
                self.countryImageView.image = country.flag
                self.countryCodeButton.setTitle(country.dialingCode, for: .normal)
            }
            
            countryController.detailColor = UIColor.blue
            countryController.labelColor = UIColor.green
            countryController.isHideFlagImage = !showCountryFlagSwitch.isOn
            countryController.isHideDiallingCode = !showDialingCodeSwitch.isOn
        case false:
            let countryController = CountryPickerController.presentController(on: self) { (country: Country) in
                self.countryImageView.image = country.flag
                self.countryImageView.isHidden = false
                self.countryCodeButton.setTitle(country.dialingCode, for: .normal)
            }
            countryController.detailColor = UIColor.blue
            countryController.labelColor = UIColor.green
            countryController.isHideFlagImage = !showCountryFlagSwitch.isOn
            countryController.isHideDiallingCode = !showDialingCodeSwitch.isOn
        }
    }
}
