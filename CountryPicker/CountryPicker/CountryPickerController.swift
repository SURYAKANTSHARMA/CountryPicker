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
    internal var countries = [Country]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    internal var filterCountries = [Country]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    internal var applySearch = false
    // To be set by client
    public var onSelectCountry: OnSelectCountryCallback?
    
    #if SWIFT_PACKAGE
        let bundle = Bundle.module
    #else
        let bundle = Bundle(for: CountryPickerController.self)
    #endif
    
    //MARK: View and ViewController
    internal lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.barStyle = .default
        searchController.searchBar.sizeToFit()
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    internal lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets.zero
        tableView.estimatedRowHeight = 70.0
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    public var favoriteCountriesLocaleIdentifiers = [String]() {
        didSet {
            self.loadCountries()
            self.tableView.reloadData()
        }
    }
    internal var isFavoriteEnable: Bool { return !favoriteCountries.isEmpty }
    internal var favoriteCountries: [Country] {
        return self.favoriteCountriesLocaleIdentifiers
            .compactMap {manager.country(withCode: $0) }
    }
    /// Properties for countryPicker controller
    public var statusBarStyle: UIStatusBarStyle? = .default
    public var isStatusBarVisible = true
    
    public struct Configuration {
        public var flagStyle: CountryFlagStyle = CountryFlagStyle.normal
        public var labelFont: UIFont = UIFont.preferredFont(forTextStyle: .title3)
        public var labelColor: UIColor = UIColor.black
        public var detailFont: UIFont = UIFont.preferredFont(forTextStyle: .subheadline)
        public var detailColor: UIColor = UIColor.lightGray
        public var separatorLineColor: UIColor = UIColor(red: 249/255.0, green: 248/255.0, blue: 252/255.0, alpha: 1.0)
        public var isCountryFlagHidden: Bool = false
        public var isCountryDialHidden: Bool = false
    }
    
    public var configuration = Configuration() {
        didSet {
            if isViewLoaded {
                tableView.reloadData()
            }
        }
    }
    
    internal var checkMarkImage: UIImage? {
        return UIImage(named: "tickMark", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    }
    internal var manager: CountryListDataSource
    internal var engine: CountryPickerEngine
    
    init(manager: CountryListDataSource) {
        self.manager = manager
        self.engine = CountryPickerEngine(countries: manager.allCountries([]))
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    private func setUpsSearchController() {
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            view.backgroundColor = UIColor.systemBackground
        } else {
            view.backgroundColor = UIColor.white
        }
        
        // Setup view bar buttons
        let uiBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop,
                                              target: self,
                                              action: #selector(self.crossButtonClicked(_:)))
        
        navigationItem.leftBarButtonItem = uiBarButtonItem
        
        // Setup table view and cells
        setUpTableView()
        
        tableView.register(CountryCell.self, forCellReuseIdentifier: CountryCell.reuseIdentifier)
        
        // Setup search controller view
        setUpsSearchController()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadCountries()
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = true
        
        /// Request for previous country and automatically scroll table view to item
        if let previousCountry = manager.lastCountrySelected {
            scrollToCountry(previousCountry)
        }
    }
    
    private func setUpTableView() {
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    open class func presentController(
        on viewController: UIViewController,
        configuration: (CountryPickerController) -> Void = {_ in },
        manager: CountryListDataSource = CountryManager.shared,
        handler: @escaping OnSelectCountryCallback)  {
            
        let controller = CountryPickerController(manager: manager)
        controller.onSelectCountry = handler
        configuration(controller)
        let navigationController = UINavigationController(rootViewController: controller)
        viewController.present(navigationController, animated: true, completion: nil)
    }
    /***
     This method returns CountryPickerController. Client is reponsible for embeddeding in navigation controller or any other view accordingly.
     */
    open class func create(manager: CountryListDataSource = CountryManager.shared,
                           handler: @escaping OnSelectCountryCallback) -> CountryPickerController {
        let controller = CountryPickerController(manager: manager)
        controller.onSelectCountry = handler
        return controller
    }
    
    
    // MARK: - Cross Button Action
    @objc private func crossButtonClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}


// MARK: - Internal Methods 
internal extension CountryPickerController {

    func loadCountries() {
        countries = manager.allCountries(favoriteCountriesLocaleIdentifiers)
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
        return applySearch ? filterCountries.count : countries.count
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
        
        if let lastSelectedCountry = manager.lastCountrySelected {
            cell.checkMarkImageView.isHidden = country.countryCode == lastSelectedCountry.countryCode ? false : true
        }
        
        cell.country = country
        setUpCellProperties(cell: cell)
        
        return cell
    }
    
    func setUpCellProperties(cell: CountryCell) {
        // Auto-hide flag & dial labels
        cell.hideFlag(configuration.isCountryFlagHidden)
        cell.hideDialCode(configuration.isCountryDialHidden)
        
        cell.nameLabel.font = configuration.labelFont
        if #available(iOS 13.0, *) {
            cell.nameLabel.textColor = UIColor.label
        } else {
            // Fallback on earlier versions
            cell.nameLabel.textColor = configuration.labelColor
        }
        cell.diallingCodeLabel.font = configuration.detailFont
        cell.diallingCodeLabel.textColor = configuration.detailColor
        cell.separatorLineView.backgroundColor = configuration.separatorLineColor
        cell.applyFlagStyle(configuration.flagStyle)
    }
    
    // MARK: - TableView Delegate
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedCountry = countries[indexPath.row]
        var dismissWithAnimation = true
        
        if applySearch {
            selectedCountry = filterCountries[indexPath.row]
            dismissWithAnimation = false
        }
        
        onSelectCountry?(selectedCountry)
        manager.lastCountrySelected = selectedCountry
            
        dismiss(animated: dismissWithAnimation, completion: nil)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath)
        -> CGFloat {
        return 60.0
    }
    
}

// MARK: - UISearchBarDelegate
extension CountryPickerController: UISearchBarDelegate {
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let searchTextTrimmed = searchBar.text?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let searchText = searchTextTrimmed, !searchText.isEmpty else {
            self.applySearch = false
            self.filterCountries.removeAll()
            self.tableView.reloadData()
            return
        }
        
        applySearch = true
        filterCountries.removeAll()
        
        let filteredCountries = engine
            .filterCountries(searchText: searchText)
    
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
