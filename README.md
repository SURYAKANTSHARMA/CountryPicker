# CountryPicker

This library is for country picker used in many app for selecting country code of user. User can select country by searching and then selecting country cell.


## Getting Started

This project use swift 4.0 and xcode 9.0. You can download locally and run the code. You can customize and use according to your need. 
example:
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
   
    let country = CountryManager.currentCountry
    countryCodeButton.setTitle(country?.dialingCode(), for: .normal)
    countryImageView.image = country?.flag
    countryCodeButton.clipsToBounds = true
    
  }
  
  
  @IBAction func countryCodeButtonClicked(_ sender: UIButton) {
    
    let countryController = CountryPickerController.presentController(on: self) { (country: Country) in
      self.countryImageView.image = country.flag
      self.countryCodeButton.setTitle(country.dialingCode(), for: .normal)

    }
    countryController.detailColor = UIColor.red
   }  
}
```
## Contributing

Any contribution making project better is welcome.

## ScreenShots
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


