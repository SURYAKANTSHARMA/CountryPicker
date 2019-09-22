![CountryPicker](https://user-images.githubusercontent.com/6416095/50628070-6fe1fd00-0f5c-11e9-9e9b-7e6dac866d43.png)

# CountryPicker
[![Travis CI](https://api.travis-ci.org/SURYAKANTSHARMA/CountryPicker.svg?branch=master)](https://travis-ci.org/SURYAKANTSHARMA/CountryPicker) 
[![codecov](https://codecov.io/gh/SURYAKANTSHARMA/CountryPicker/branch/master/graph/badge.svg)](https://codecov.io/gh/SURYAKANTSHARMA/CountryPicker)
[![Version](https://img.shields.io/cocoapods/v/SKCountryPicker.svg?style=flat)](https://cocoapods.org/pods/SKCountryPicker)
[![License](https://img.shields.io/badge/License-MIT-8D6E63.svg)](LICENSE)  


A simple, customizable Country picker for picking country or dialing code.  

This library is for country picker used in many app for selecting country code of user. User can select country by searching and then selecting country in list.

## If you like CountryPicker, give it a ★ at the top right of this page.

## Features

- [x] Navigate through search and index title of section e.g (in Contact app in iOS)
- [x] Auto scroll to previous selected country
- [x] Filtering country options 
- [x] Styling view options
- [x] Image size are optimized 
- [x] Cocoa Pods integrated
- [x] Best practices followed
- [x] Dark mode supported in iOS 13
- [x] Support Dynamic font size for ContentSizeCategory  

## Requirements

- iOS 10.0+ Support latest release iOS 13
- Xcode 10.2+ Support latest Xcode 11

## Demo Project
To run the example project, clone the repo, and run pod update from the Example directory first. 

<img src= "Usage Resource/SKCountryPickerDemo.gif" width="200" height = "400"> 

## Screenshots 
| Home Scene        | Country Picker Scene  | Filtering Scene | Dark Mode Scene |
|:-----------------:|:---------------------:| :--------------:| :--------------:| 
|<img src= "Usage Resource/SKCountryPickerHomeScene.png" width="166" height = "330">|<img src= "Usage Resource/SKCountryPickerScene.png" width="166" height = "330">| <img src= "Usage Resource/SKCountryPickerFilterScene.png" width="166" height = "330">| <img src= "Usage Resource/DarkMode.png" width="166" height = "330">|


## Installation

CountryPicker is available through Cocoapods.

#### [CocoaPods](http://cocoapods.org):
Add the following line to your Podfile:
```ruby
pod 'SKCountryPicker'
```
Current version compatible with Swift 5.
If you want support Swift 4.1/3.3

```ruby
pod 'SKCountryPicker' '~> 1.2.0'
```
## Getting Started
Example:

```swift
import UIKit
import SKCountryPicker
class ViewController: UIViewController  {
  //MARK:- IBOutlet
  @IBOutlet weak var countryCodeButton: UIButton!
  @IBOutlet weak var countryImageView: UIImageView!
  
  //MARK:- Func
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
   
    guard let country = CountryManager.shared.currentCountry else {
        self.countryCodeButton.setTitle("Pick Country", for: .normal)
        self.countryImageView.isHidden = true
        return
    }
    
    countryCodeButton.setTitle(country.dialingCode, for: .normal)
    countryImageView.image = country.flag
    countryCodeButton.clipsToBounds = true
  }
  
  
  @IBAction func countryCodeButtonClicked(_ sender: UIButton) {
    
    // Invoke below static method to present country picker without section control
    // CountryPickerController.presentController(on: self) { ... } 
    
    let countryController = CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in
      
      guard let self = self else { return }
      
      self.countryImageView.image = country.flag
      self.countryCodeButton.setTitle(country.dialingCode, for: .normal)

    }
    
    // can customize the countryPicker here e.g font and color
    countryController.detailColor = UIColor.red
   }
}
```

## Filter Options
There are 3 main filter options `countryName`, `countryCode`, `countryDialCode` and  by default country picker has been configured to filter countries based on `countryName`. 

If you want to add/remove filter options, do as follows: 
```swift 

 // Adding filter
 CountryManager.shared.addFilter(.countryCode)
 
 // Removing filter 
 CountryManager.shared.removeFilter(.countryCode)
 
 // Removing all filters 
 CountryManager.shared.clearAllFilters() 
```

Incase you want to retrieve  `country` info 
```swift 

// Get country based on digit code e.g: 60, +255
CountryManager.shared.country(withDigitCode: "255")

// Get country based on country name
CountryManager.shared.country(withName: "Tanzania")

// Get country based on country code e.g: MY, TZ
CountryManager.shared.country(withCode: "MY")

```

## Styling Options
There are few styling options provided by the library such auto-hiding or styling views.
```swift 

let countryController = CountryPickerWithSectionViewController.presentController(on: self) { ... } 

// Styling country flag image view 
countryController.flagStyle = .corner    // E.g .corner, ,circular or .normal 

// Hide flag image view 
countryController.isCountryFlagHidden = true // False 

// Hide country dial code 
countryController.isCountryDialHidden = true  // False

```

## Contributing

Any contribution making project better is welcome.

## Authors

[***Suryakant Sharma**](https://github.com/SURYAKANTSHARMA)

See also the list of [contributors](https://github.com/SURYAKANTSHARMA/CountyPicker/contributors) who participated in this project. Thanks from bottom of my heart to inspiration behind <a href="https://github.com/hardeep-singh">Hardeep Singh</a>

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details





