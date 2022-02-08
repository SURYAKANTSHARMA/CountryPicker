![CountryPicker](https://user-images.githubusercontent.com/6416095/50628070-6fe1fd00-0f5c-11e9-9e9b-7e6dac866d43.png)

# CountryPicker
[![Awesome](https://cdn.rawgit.com/sindresorhus/awesome/d7305f38d29fed78fa85652e3a63e154dd8e8829/media/badge.svg)](https://github.com/vsouza/awesome-ios)
[![Travis CI](https://api.travis-ci.org/SURYAKANTSHARMA/CountryPicker.svg?branch=master)](https://travis-ci.org/SURYAKANTSHARMA/CountryPicker)
[![codecov](https://codecov.io/gh/SURYAKANTSHARMA/CountryPicker/branch/master/graph/badge.svg)](https://codecov.io/gh/SURYAKANTSHARMA/CountryPicker)
[![Version](https://img.shields.io/cocoapods/v/SKCountryPicker.svg?style=flat)](https://cocoapods.org/pods/SKCountryPicker)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
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
- [x] Carthage integrated
- [x] Swift package manager integrated
- [x] Best practices followed
- [x] Dark mode supported in iOS 13
- [x] Support Dynamic font size for ContentSizeCategory
- [x] Unit tests coverage 94%
- [x] Picker view support added with customization 

## Requirements

- iOS 11.0+ Support latest release iOS 13
- latest Xcode 13.x with Swift 

## Demo Project
To run the example project, clone the repo, and run pod update from the Example directory first.

<img src= "Usage Resource/SKCountryPickerDemo.gif" width="200" height = "400">

## Screenshots
| Home Scene        | Country Picker Scene  | Filtering Scene | Dark Mode Scene | Picker View |
|:-----------------:|:---------------------:|:--------------:|:--------------:|:--------------:|
|<img src= "Usage Resource/SKCountryPickerHomeScene.png" width="166" height = "330">|<img src= "Usage Resource/SKCountryPickerScene.png" width="166" height = "330">| <img src= "Usage Resource/SKCountryPickerFilterScene.png" width="166" height = "330">| <img src= "Usage Resource/DarkMode.png" width="166" height = "330">|  <img src= "Usage Resource/pickerView.png" width="166" height = "330">|


## Installation

CountryPicker is available through Cocoapods and Carthage.

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

#### [Carthage](https://github.com/Carthage/Carthage)
The steps required to use Carthage for dependency management are described [here](https://github.com/Carthage/Carthage#getting-started) but lets add them to this README as well for good measure.

First you need to add the following line to your Cartfile

```
github "SURYAKANTSHARMA/CountryPicker"
```

to include the latest version of CountryPicker.

(if you don't have a Cartfile, you need to create one first in your favorite texteditor)

Next run

```
carthage update --platform iOS
```

This will have Carthage:
- Fetch the source code for CountryPicker from Github
- Compile the source code into a framework for you to use

once Carthage finishes building, you need to add the framework to your project.

In Xcode:

- Navigate to the "General" tab of your project and tap the plus sign under "Frameworks, Libraries and Embedded Content"
- Select "Add other" and locate the Carthage folder (typically in the root of your project)
- The SKCountryPicker.framework is located under `Carthage/Build/iOS/`
- Select it and verify that it is added as a framework.

The final step is to add the `copy-frameworks` build script to your "Build Phases".

- Navigate to "Build Phases" and tap the + at the top.
- Select "New Run Script Phase"
- Paste this line as the script to run `/usr/local/bin/carthage copy-frameworks`
- Add the SKCountryPicker.framework under Input Files like so: `$(SRCROOT)/Carthage/Build/iOS/SKCountryPicker.framework`

Done!

#### [SPM](https://swift.org/package-manager/)

Add the following line to your Package.swift file in the dependencies section:

```
.package(url: "https://github.com/SURYAKANTSHARMA/CountryPicker.git, from "1.2.7")
```

## Getting Started
Example:
Please  check [example](https://github.com/SURYAKANTSHARMA/CountryPicker/tree/master/Example) project for customization and different option available.
```swift 
    func presentCountryPickerScene(withSelectionControlEnabled selectionControlEnabled: Bool = true) {
        switch selectionControlEnabled {
        case true:
            // Present country picker with `Section Control` enabled
            CountryPickerWithSectionViewController.presentController(on: self, configuration: { countryController in
                countryController.configuration.flagStyle = .circular
                countryController.configuration.isCountryFlagHidden = !showCountryFlagSwitch.isOn
                countryController.configuration.isCountryDialHidden = !showDialingCodeSwitch.isOn
                countryController.favoriteCountriesLocaleIdentifiers = ["IN", "US"]

            }) { [weak self] country in
                
                guard let self = self else { return }
                self.countryImageView.isHidden = false
                self.countryImageView.image = country.flag
                self.countryCodeButton.setTitle(country.dialingCode, for: .normal)
            }
            
        case false:
            // Present country picker without `Section Control` enabled
            CountryPickerController.presentController(on: self, configuration: { countryController in
                countryController.configuration.flagStyle = .corner
                countryController.configuration.isCountryFlagHidden = !showCountryFlagSwitch.isOn
                countryController.configuration.isCountryDialHidden = !showDialingCodeSwitch.isOn
                countryController.favoriteCountriesLocaleIdentifiers = ["IN", "US"]

            }) { [weak self] country in
                
                guard let self = self else { return }
                
                self.countryImageView.isHidden = false
                self.countryImageView.image = country.flag
                self.countryCodeButton.setTitle(country.dialingCode, for: .normal)
            }
        }
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
