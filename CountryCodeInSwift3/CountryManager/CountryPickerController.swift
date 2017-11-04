//
//  CountryPickerController.swift
//  CountryCodeInSwift3
//
//  Created by cl-macmini-68 on 09/02/17.
//  Copyright © 2017 Suryakant. All rights reserved.
//

import UIKit

class CountryPickerController: UIViewController {
  
  
  //MARK:- Variables
  var tableView: UITableView!
  fileprivate var countries = [Country]()
  fileprivate var filterCountries = [Country]()
  fileprivate var applySearch = false
  fileprivate var _presentingViewController: UIViewController?
  fileprivate var callBack : (( _ chosenCountry: Country) -> Void)?
  fileprivate var searchController: UISearchController?
  
  public var statusBarStyle : UIStatusBarStyle? = .default
  public var isStatusBarVisible = true
  
  public var labelFont = UIFont.systemFont(ofSize: 14.0) {
    willSet {
      self.tableView?.reloadData()
    }
  }
  public var labelColor = UIColor.black {
    willSet {
      self.tableView?.reloadData()
    }
  }
  
  public var detailFont = UIFont.systemFont(ofSize: 11.0) {
    willSet {
      self.tableView?.reloadData()
    }
  }
  public var detailColor = UIColor.lightGray {
    willSet {
      self.tableView?.reloadData()
    }
  }
  
  public var separatorLineColor = UIColor.lightGray {
    willSet {
      self.tableView?.reloadData()
    }
  }
  
  public var isHideFlagImage: Bool = false {
    willSet {
      self.tableView?.reloadData()
    }
  }
  
  public var isHideDiallingCode: Bool = false {
    willSet {
      self.tableView?.reloadData()
    }
  }
  

  //MARK:- View life cycle
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    self.view.addSubview(tableView)
    self.view.backgroundColor = UIColor.white
    self.tableView.backgroundColor = UIColor.white
    
    navigationController?.navigationBar.isTranslucent = false
    let uiBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(CountryPickerController.crossButtonClicked(_:)))
    self.navigationItem.leftBarButtonItem = uiBarButtonItem
    
    let nib = UINib(nibName: "CountryTableViewCell", bundle: nil)
    tableView.register(nib, forCellReuseIdentifier: "CountryTableViewCell")
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorStyle = .none
    
    searchController = UISearchController(searchResultsController: nil)
    searchController?.hidesNavigationBarDuringPresentation = true
    searchController?.dimsBackgroundDuringPresentation = false
    searchController?.searchBar.barStyle = .default
    searchController?.searchBar.sizeToFit()
    searchController?.searchBar.delegate = self;
    searchController?.searchBar.placeholder = "search country name here.."
    tableView.tableHeaderView = searchController?.searchBar
    self.definesPresentationContext = true
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    loadCountries()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true)
  }
  
  @discardableResult
  class func presentController(on viewController: UIViewController, callBack:@escaping (_ chosenCountry: Country)->Void) -> CountryPickerController{
    let controller = CountryPickerController()
    controller._presentingViewController = viewController
    controller.callBack = callBack
    let navigationController = UINavigationController(rootViewController: controller)
    controller._presentingViewController?.present(navigationController, animated: true, completion: nil)
    return controller
  }
  
  //MARK:- Cross Button Action
  func crossButtonClicked(_ sender : UIBarButtonItem){
    self.dismiss(animated: true, completion: nil)
  }
  
  //MARK:- Others
  func loadCountries(){
    countries = CountryManager.shared.allCountries()
    tableView.reloadData()
  }
}

// MARK: - TableView DataSource
extension CountryPickerController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch applySearch {
    case false:
      return countries.count
    case true:
      return filterCountries.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTableViewCell") as? CountryTableViewCell {
      cell.accessoryType = .none
      cell.checkmarkImageView.isHidden = true
      
      let image = UIImage(named: "tickMark")!.withRenderingMode(.alwaysTemplate)
      cell.checkmarkImageView.image = image
      
      var country: Country
      if applySearch {
        country = filterCountries[indexPath.row]
      }else {
         country = countries[indexPath.row]
      }
      
      if let _country = CountryManager.shared.lastCountrySelected {
        let isEqual = (country.countryCode == _country.countryCode)
        if isEqual{
          cell.checkmarkImageView.isHidden = false
        }
      }
      cell.nameLabel?.text = country.countryName
      cell.diallingCodeLabel?.text = country.dialingCode()
      
      let imagePath = country.imagePath
      if let image = UIImage(named: imagePath, in: nil, compatibleWith: nil){
        cell.flagImageView?.image = image
      }
      
      cell.nameLabel.font = self.labelFont
      cell.nameLabel.textColor = self.labelColor
      cell.diallingCodeLabel.font = self.detailFont
      cell.diallingCodeLabel.textColor = self.detailColor
      cell.flagImageView.isHidden = self.isHideFlagImage
      cell.diallingCodeLabel.isHidden = self.isHideDiallingCode
      cell.separatorLine.backgroundColor = self.separatorLineColor
      return cell
    }
    
    return UITableViewCell()
  }
  
  //MARK:- TableView Delegate
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch applySearch {
    case true:
      let country = filterCountries[indexPath.row]
      self.callBack?(country)
      CountryManager.shared.lastCountrySelected = country
    case false:
      let country = countries[indexPath.row]
      self.callBack?(country)
      CountryManager.shared.lastCountrySelected = country
    }
    tableView.deselectRow(at: indexPath, animated: true)
    tableView.reloadData()
    self.dismiss(animated: true, completion: nil)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50.0
  }
 
}

extension CountryPickerController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
  }
}



extension CountryPickerController: UISearchBarDelegate {
  
  // MARK: - SearchBar Delegate
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    //code for filter
    if searchBar.text != ""{
      applySearch = true
      filterCountries = []
      let searchString = searchBar.text
      for country in countries{
        if ((country.countryName.uppercased()) as NSString).hasPrefix((searchString?.uppercased())!){
          self.filterCountries.append(country)
        }
      }
    }
    else{
      applySearch = false
    }
    // Reload the tableview.
    tableView.reloadData()
  }
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.text = ""
    applySearch = false
    searchBar.resignFirstResponder()
    tableView.reloadData()
  }
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.endEditing(true)
  }
}




