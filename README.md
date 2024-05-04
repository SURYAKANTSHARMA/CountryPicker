![CountryPicker](https://user-images.githubusercontent.com/6416095/50628070-6fe1fd00-0f5c-11e9-9e9b-7e6dac866d43.png)

# CountryPicker
[![Awesome](https://cdn.rawgit.com/sindresorhus/awesome/d7305f38d29fed78fa85652e3a63e154dd8e8829/media/badge.svg)](https://github.com/vsouza/awesome-ios)
[![Build Status](https://img.shields.io/badge/Build-BUILD_STATUS_PLACEHOLDER-red)](https://github.com/SURYAKANTSHARMA/CountryPicker/actions)

<!-- Your project description and other contents below -->

[![codecov](https://codecov.io/gh/SURYAKANTSHARMA/CountryPicker/branch/master/graph/badge.svg)](https://codecov.io/gh/SURYAKANTSHARMA/CountryPicker)
![Version Badge](https://img.shields.io/github/v/release/SURYAKANTSHARMA/CountryPicker?style=flat)

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![License](https://img.shields.io/badge/License-MIT-8D6E63.svg)](LICENSE)  


CountryPicker is a Swift library that provides a simple and easy-to-use interface for selecting countries from a predefined list. It's perfect for adding country selection functionality to your iOS app with minimal effort.


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
- [x] Dark mode supported 
- [x] Support Dynamic font size for ContentSizeCategory
- [x] Unit tests coverage 94%
- [x] Picker view support added with customization 
- [x] Swift UI Support with example project
- [x] Rewritten with swiftUI and combine in version 3.0.0  
## Requirements

- iOS 11.0+ Support latest release iOS 17
- iOS 15+ for 3.0.0 and above version of cocoapod
- latest Xcode 15.x with Swift 

## Demo Project
To run the example project, clone the repo, and run pod update from the Example directory first.

<img src= "Usage Resource/SKCountryPickerDemo.gif" width="200" height = "400">

#### Swift UI Combine new project 
<img src= "Usage Resource/SKCountryPicker15Plus.gif" width="200" height = "400">|


##  

## Screenshots
| Home Scene        | Country Picker Scene  | Filtering Scene | Dark Mode Scene | Picker View |
|:-----------------:|:---------------------:|:--------------:|:--------------:|:--------------:|
|<img src= "Usage Resource/SKCountryPickerHomeScene.png" width="166" height = "330">|<img src= "Usage Resource/SKCountryPickerScene.png" width="166" height = "330">| <img src= "Usage Resource/SKCountryPickerFilterScene.png" width="166" height = "330">| <img src= "Usage Resource/DarkMode.png" width="166" height = "330">|  <img src= "Usage Resource/pickerView.png" width="166" height = "330">|


## Installation

CountryPicker is available through Cocoapods and Carthage.

#### [CocoaPods](http://cocoapods.org):
Add the following line to your Podfile:

```ruby
For supporting iOS 15 or below 
pod 'SKCountryPicker'

For iOS 15 and above (Combine and Swiftui version) currently only supported by cocoapods 
pod 'SKCountryPicker', :git => 'https://github.com/SURYAKANTSHARMA/CountryPicker', :branch => 'iOS15AndAbove'

```

Please note iOS 15 will be discontinued after in 2024. 
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
Please  check [baseiOS11Example](https://github.com/SURYAKANTSHARMA/CountryPicker/tree/master/Examples) project for customization and different option available for using with old uikit.

Please check [baseiOS15Example](https://github.com/SURYAKANTSHARMA/CountryPicker/tree/master/CountryPickeriOS15%2B/CountryPicker13%2BExample) project for using it in swift ui app with minimum deployment target iOS 15


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
## Dependency Graph 

![Dependecy graph](https://user-images.githubusercontent.com/6416095/181878996-43ef2361-5d81-4bef-9f84-f4c54a640ed6.png)
#### For swift ui 

- [x] use 3.0.0 and above version 

## Contributing

Any contribution making project better is welcome.

## Authors

[***Suryakant Sharma**](https://github.com/SURYAKANTSHARMA)

See also the list of [contributors](https://github.com/SURYAKANTSHARMA/CountyPicker/contributors) who participated in this project. Thanks from bottom of my heart to inspiration behind <a href="https://github.com/hardeep-singh">Hardeep Singh</a>

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
