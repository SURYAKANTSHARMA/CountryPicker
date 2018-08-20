# CountryPicker

This library is for country picker used in many app for selecting country code of user. User can select country by searching and then selecting country cell.

## Installation

CountryPicker is available through Cocoapods.

#### [CocoaPods](http://cocoapods.org):
Add the following line to your Podfile:

```ruby
pod ‘CountryPicker’, :git => ‘https://github.com/SURYAKANTSHARMA/CountryPicker/’, :tag => ‘1.0.4’
```

## Getting Started
Example:

```swift
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
```


## Contributing

Any contribution making project better is welcome.



## ScreenShots

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

***Suryakant Sharma**(https://github.com/SURYAKANTSHARMA)

See also the list of [contributors](https://github.com/SURYAKANTSHARMA/CountyPicker/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details






