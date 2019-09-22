//
//  CountryPickerController.swift
//  CountryCodeInSwift3
//
//  Created by cl-macmini-68 on 09/02/17.
//  Copyright © 2017 Suryakant. All rights reserved.
//

import UIKit


/// Country flag styles
public enum CountryFlagStyle {
    
    // Corner style will be applied
    case corner
    
    // Circular style will be applied
    case circular
    
    // Rectangle style will be applied
    case normal
}


open class CountryPickerController: UIViewController {
    
    // MARK: - Variables
    var countries = [Country]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var filterCountries = [Country]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var applySearch = false
    var callBack: (( _ choosenCountry: Country) -> Void)?
    
    let bundle = Bundle(for: CountryPickerController.self)
    
    //MARK: View and ViewController
    var presentingVC: UIViewController?
    var searchController = UISearchController(searchResultsController: nil)
    let tableView =  UITableView()
    
    /// Properties for countryPicker controller
    public var statusBarStyle: UIStatusBarStyle? = .default
    public var isStatusBarVisible = true
    
    public var flagStyle: CountryFlagStyle = CountryFlagStyle.normal {
        didSet { self.tableView.reloadData() }
    }
    
    public var labelFont: UIFont = UIFont.preferredFont(forTextStyle: .title3) {
        didSet { self.tableView.reloadData() }
    }
    
    public var labelColor: UIColor = UIColor.black {
        didSet { self.tableView.reloadData() }
    }
    
    public var detailFont: UIFont = UIFont.preferredFont(forTextStyle: .subheadline) {
        didSet { self.tableView.reloadData() }
    }
    
    public var detailColor: UIColor = UIColor.lightGray {
        didSet { self.tableView.reloadData() }
    }
    
    public var separatorLineColor: UIColor = UIColor(red: 249/255.0, green: 248/255.0, blue: 252/255.0, alpha: 1.0) {
        didSet { self.tableView.reloadData() }
    }
    
    public var isCountryFlagHidden: Bool = false {
        didSet { self.tableView.reloadData() }
    }
    
    public var isCountryDialHidden: Bool = false {
        didSet { self.tableView.reloadData() }
    }
    
    internal var checkMarkImage: UIImage? {
        return UIImage(named: "tickMark", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    }
    
    // MARK: - View life cycle
    fileprivate func setUpsSearchController() {
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.barStyle = .default
        searchController.searchBar.sizeToFit()
        searchController.searchBar.delegate = self
        
        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = searchController
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
        
        definesPresentationContext = true
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        // Setup view bar buttons
        let uiBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(CountryPickerController.crossButtonClicked(_:)))
        navigationItem.leftBarButtonItem = uiBarButtonItem
        
        // Setup table view and cells
        setUpTableView()
        
        let nib = UINib(nibName: "CountryTableViewCell", bundle: bundle)
        tableView.register(nib, forCellReuseIdentifier: "CountryTableViewCell")
        tableView.register(CountryCell.self, forCellReuseIdentifier: CountryCell.reuseIdentifier)
        
        // Setup search controller view
        setUpsSearchController()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadCountries()
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = true
        }
        
        /// Request for previous country and automatically scroll table view to item
        if let previousCountry = CountryManager.shared.lastCountrySelected {
            scrollToCountry(previousCountry)
        }
    }
    
    private func setUpTableView() {
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets.zero
        tableView.estimatedRowHeight = 70.0
        tableView.rowHeight = UITableView.automaticDimension
        
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                ])
        } else {
            // Fallback on earlier versions
            NSLayoutConstraint.activate([
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.topAnchor.constraint(equalTo: view.topAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                ])
        }
    }
    
    @discardableResult
    open class func presentController(on viewController: UIViewController, callBack:@escaping (_ chosenCountry: Country) -> Void) -> CountryPickerController {
        let controller = CountryPickerController()
        controller.presentingVC = viewController
        controller.callBack = callBack
        let navigationController = UINavigationController(rootViewController: controller)
        controller.presentingVC?.present(navigationController, animated: true, completion: nil)
        return controller
    }
    
    // MARK: - Cross Button Action
    @objc func crossButtonClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}


// MARK: - Internal Methods 
internal extension CountryPickerController {

    func loadCountries() {
        countries = CountryManager.shared.allCountries()
    }
    
    ///
    /// Automatically scrolls the `TableView` to a particular section on expected chosen country.
    ///
    /// Under the hood, it tries to find several indexes for section title and expectd chosen country otherwise execution stops.
    /// Then constructs an `IndexPath` and scrolls the rows to that particular path with animation (If enabled).
    ///
    /// - Parameter country: Expected chosen country
    /// - Parameter animated: Scrolling animation state and by default its set to `False`.
    
    func scrollToCountry(_ country: Country, animated: Bool = false) {
        
        // Find country index
        let countryMatchIndex = countries.firstIndex(where: { $0.countryCode == country.countryCode})
        
        if let itemIndexPath = countryMatchIndex {
            let previousCountryIndex = IndexPath(item: itemIndexPath, section: 0)
            tableView.scrollToRow(at: previousCountryIndex, at: .middle, animated: animated)
        }
    }
}


// MARK: - TableView DataSource
extension CountryPickerController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch applySearch {
        case false:
            return countries.count
        case true:
            return filterCountries.count
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CountryCell.reuseIdentifier) as? CountryCell else {
            fatalError("Cell with Identifier CountryTableViewCell cann't dequed")
        }
        
        cell.accessoryType = .none
        cell.checkMarkImageView.isHidden = true
        cell.checkMarkImageView.image = checkMarkImage
        
        var country: Country
        
        if applySearch {
            country = filterCountries[indexPath.row]
        } else {
            country = countries[indexPath.row]
        }
        
        if let alreadySelectedCountry = CountryManager.shared.lastCountrySelected {
            cell.checkMarkImageView.isHidden = country.countryCode == alreadySelectedCountry.countryCode ? false : true
        }
        
        cell.country = country
        setUpCellProperties(cell: cell)
        
        return cell
    }
    
    func setUpCellProperties(cell: CountryCell) {
        
        // Auto-hide flag & dial labels
        cell.hideFlag(isCountryFlagHidden)
        cell.hideDialCode(isCountryDialHidden)
        
        cell.nameLabel.font = labelFont
        if #available(iOS 13.0, *) {
            cell.nameLabel.textColor = UIColor.label
        } else {
            // Fallback on earlier versions
            cell.nameLabel.textColor = labelColor
        }
        cell.diallingCodeLabel.font = detailFont
        cell.diallingCodeLabel.textColor = detailColor
        cell.separatorLineView.backgroundColor = self.separatorLineColor
        cell.applyFlagStyle(flagStyle)
    }
    
    // MARK: - TableView Delegate
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch applySearch {
        case true:
            let country = filterCountries[indexPath.row]
            self.callBack?(country)
            CountryManager.shared.lastCountrySelected = country
            self.dismiss(animated: false, completion: nil)
        case false:
            let country = countries[indexPath.row]
            self.callBack?(country)
            CountryManager.shared.lastCountrySelected = country
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
}

// MARK: - UISearchBarDelegate
extension CountryPickerController: UISearchBarDelegate {
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let searchTextTrimmed = searchBar.text?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let searchText = searchTextTrimmed, searchText.isEmpty == false else {
            self.applySearch = false
            self.filterCountries.removeAll()
            self.tableView.reloadData()
            return
        }
        
        applySearch = true
        filterCountries.removeAll()
        
        let filteredCountries = countries.compactMap { (country) -> Country? in

            // Filter country by country name first character
            if CountryManager.shared.defaultFilter == .countryName,
                country.countryName.lowercased().contains(searchText) {
                return country
            }

            // Filter country by country code and utilise `CountryFilterOptions`
            if CountryManager.shared.filters.contains(.countryCode),
                country.countryCode.lowercased().contains(searchText) {
                return country
            }

            // Filter country by digit country code and utilise `CountryFilterOptions`
            if CountryManager.shared.filters.contains(.countryDialCode),
                let digitCountryCode = country.digitCountrycode, digitCountryCode.contains(searchText) {
                return country
            }

            return nil
        }
        
        // Append filtered countries
        filterCountries.append(contentsOf: filteredCountries)
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        applySearch = false
        tableView.reloadData()
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
