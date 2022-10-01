[![Version](https://img.shields.io/cocoapods/v/SKCountryPicker.svg?style=flat)](https://cocoapods.org/pods/SKCountryPicker)
[![License](https://img.shields.io/badge/License-MIT-8D6E63.svg)](LICENSE)  
![my_tweet 1](https://user-images.githubusercontent.com/6416095/43136625-f56e1984-8f66-11e8-86f8-c2cd2882d1cc.png)

# CountryPicker


A simple, customizable Country picker for picking country or dialing code.  
This library is for country picker used in many app for selecting country code of user. User can select country by searching and then selecting country in list.

## If you like CountryPicker, give it a ★ at the top right of this page.

## Features

- [x] Navigate through search and index title of section e.g (in Contact app in iOS)
- [x] cocoa Pods integrated
- [x] Best practices followed

## Requirements

- iOS 10.0+
- Xcode 9+
## Example 
 To run the example project, clone the repo, and run pod update from the Example directory first. 
## Installation

CountryPicker is available through Cocoapods.

#### [CocoaPods](http://cocoapods.org):
Add the following line to your Podfile:

```ruby
pod 'SKCountryPicker'
```
current version compatible with Swift 4.1 as well Swift 3.3 
## Getting Started
Example:

```swift
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
    // can customize the countryPicker here e.g font and color
    countryController.detailColor = UIColor.red
   }
}
```


## Contributing

Any contribution making project better is welcome.



## ScreenShots
In Example Project  

<img src= "https://user-images.githubusercontent.com/6416095/44832120-2c425400-ac47-11e8-9b3d-d96474942f46.gif" width="200" height = "400"> 

Demo   

<img src= "https://user-images.githubusercontent.com/6416095/34318079-4dcec342-e7e4-11e7-9d33-933db60d4836.gif" width="200" height = "400">

Above is a Gif demo.

After running the project by default current country get selected as below.

![defaultopenimage](https://github.com/senseiphoneX/CountyPicker/blob/master/Usage%20Resource/screenshot1.png)



On clicking on this button country picker open with the option of choose or filter the require country.
![step2image](https://github.com/senseiphoneX/CountyPicker/blob/master/Usage%20Resource/screenshot2.png)


After selecting selected country with image will appear on your button.
![simulator screen shot - iphone 5s - 2017-10-29 at 17 32 52](https://github.com/senseiphoneX/CountyPicker/blob/master/Usage%20Resource/screenshot3.png)
![simulator screen shot - iphone 5s - 2017-10-29 at 17 32 56](https://github.com/senseiphoneX/CountyPicker/blob/master/Usage%20Resource/screenshot4.png)


## Authors

[***Suryakant Sharma**](https://github.com/SURYAKANTSHARMA)

See also the list of [contributors](https://github.com/SURYAKANTSHARMA/CountyPicker/contributors) who participated in this project. Thanks from bottom of my heart to inspiration behind <a href="https://github.com/hardeep-singh">Hardeep Singh</a>

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details






