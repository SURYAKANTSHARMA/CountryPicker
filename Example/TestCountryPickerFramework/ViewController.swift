//
//  ViewController.swift
//  TestCountryPickerFramework
//
//  Created by SuryaKant Sharma on 11/03/18.
//  Copyright © 2018 SuryaKant Sharma. All rights reserved.
//

import UIKit
import SKCountryPicker

class ViewController: UIViewController  {
    //MARK:- IBOutlet
    @IBOutlet weak var countryCodeButton: UIButton!
    @IBOutlet weak var countryImageView: UIImageView!
    let contryPickerController = CountryPickerController()
    
    //MARK:- Func
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let country = CountryManager.shared.currentCountry
        countryCodeButton.setTitle(country?.dialingCode, for: .normal)
        countryImageView.image = country?.flag
        countryCodeButton.clipsToBounds = true
        
    }
    
    
    @IBAction func countryCodeButtonClicked(_ sender: UIButton) {
        
        let countryController = CountryPickerWithSectionViewController.presentController(on: self) { (country: Country) in
            self.countryImageView.image = country.flag
            self.countryCodeButton.setTitle(country.dialingCode, for: .normal)
            
        }
        countryController.detailColor = UIColor.red
    }
}
