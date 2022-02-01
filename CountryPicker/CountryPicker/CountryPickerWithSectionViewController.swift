//
//  CountryPickerWithSectionViewController.swift
//  CountryCodeInSwift3
//
//  Created by SuryaKant Sharma on 16/12/17.
//  Copyright © 2017 Suryakant. All rights reserved.
//

import UIKit

open class CountryPickerWithSectionViewController: CountryPickerController {

    // MARK: - Variables
    private(set) var sections: [Character] = []
    private(set) var sectionCoutries =  [Character: [Country]]()
    private(set) var searchHeaderTitle: Character = "A"

    // MARK: - View Life Cycle
    override open func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = nil
        tableView.delegate = nil
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchSectionCountries()
        tableView.dataSource = self
        tableView.delegate = self
    }

    open override func viewDidAppear(_ animated: Bool) {
        navigationItem.hidesSearchBarWhenScrolling = true
        scrollToPreviousCountryIfNeeded()
    }
    
    internal func scrollToPreviousCountryIfNeeded() {
        /// Request for previous country and automatically scroll table view to item
        if let previousCountry = manager.lastCountrySelected {
           let previousCountryFirstCharacter = previousCountry.countryName.first!
           scrollToCountry(previousCountry, withSection: previousCountryFirstCharacter)
        }
    }
    
    open override class func presentController(
        on viewController: UIViewController,
        configuration: (CountryPickerController) -> Void = {_ in },
        manager: CountryListDataSource = CountryManager.shared,
        handler:@escaping OnSelectCountryCallback) {
        
        let controller = CountryPickerWithSectionViewController(manager: manager)
        controller.onSelectCountry = handler
        configuration(controller)
        let navigationController = UINavigationController(rootViewController: controller)
        viewController.present(navigationController, animated: true, completion: nil)
    }

}


// MARK: - Internal Methods
internal extension CountryPickerWithSectionViewController {
    
    ///
    /// Automatically scrolls the `TableView` to a particular section on expected chosen country.
    ///
    /// Under the hood, it tries to find several indexes for section title and expectd chosen country otherwise execution stops.
    /// Then constructs an `IndexPath` and scrolls the rows to that particular path with animation (If enabled).
    ///
    /// - Parameter country: Expected chosen country
    /// - Parameter sectionTitle: Character value as table section title.
    /// - Parameter animated: Scrolling animation state and by default its set to `False`.
    
    func scrollToCountry(_ country: Country, withSection sectionTitle: Character, animated: Bool = false) {
        
        if applySearch { return }
        
        // Find country index
        let countryMatchIndex = sectionCoutries[sectionTitle]?.firstIndex(where: { $0.countryCode == country.countryCode})
        
        // Find section title index
        let countrySectionKeyIndexes = sectionCoutries.keys.map { $0 }.sorted()
        let countryMatchSectionIndex = countrySectionKeyIndexes.firstIndex(of: sectionTitle)
        
        guard let row = countryMatchIndex, var section = countryMatchSectionIndex else {
            return
        }
        if isFavoriteEnable { // If favourite enable first section is by default reserved for favourite
            section += 1
        }
        tableView.scrollToRow(at: IndexPath(row: row, section: section), at: .middle, animated: true)
    }
    
    
    func fetchSectionCountries() {
        // For Favourite case we need first section empty
        if isFavoriteEnable {
            sections.append(contentsOf: "")
        }
        sections = countries.map { String($0.countryName.prefix(1)).first! }
            .removeDuplicates()
            .sorted(by: <)
        for section in sections {
            let sectionCountries = countries.filter({ $0.countryName.first! == section }).removeDuplicates()
            sectionCoutries[section] = sectionCountries
        }
    }
}


// MARK: - TableView DataSource
extension CountryPickerWithSectionViewController {

    func numberOfSections(in tableView: UITableView) -> Int {
        if applySearch {
            return 1
        }
        return isFavoriteEnable ? sections.count + 1 : sections.count
    }
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !applySearch else { return filterCountries.count }
        return numberOfRowFor(section: section)
    }

    func numberOfRowFor(section: Int) -> Int {
        if isFavoriteEnable {
            if section == 0 {
               return favoriteCountries.count
            }
            let character = sections[section-1]
            return sectionCoutries[character]!.count
        }
        let character = sections[section]
        return sectionCoutries[character]!.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard !applySearch else {
            return String(searchHeaderTitle)
        }
        
        if isFavoriteEnable {
            if section == 0 {
                return nil
            }
            return sections[section-1].description
        }

        return sections[section].description
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CountryCell.reuseIdentifier) as? CountryCell else {
            fatalError("Cell with Identifier CountryTableViewCell cann't dequed")
        }
        
        cell.accessoryType = .none
        cell.checkMarkImageView.isHidden = true
        cell.checkMarkImageView.image = checkMarkImage

        var country: Country
        
        if applySearch {
            country = filterCountries[indexPath.row]
        } else if isFavoriteEnable {
            if indexPath.section == 0 {
                country = favoriteCountries[indexPath.row]
            } else {
                let character = sections[indexPath.section-1]
                country = sectionCoutries[character]![indexPath.row]
            }
        } else {
            let character = sections[indexPath.section]
            country = sectionCoutries[character]![indexPath.row]
        }

        if let alreadySelectedCountry = manager.lastCountrySelected {
            cell.checkMarkImageView.isHidden = country.countryCode == alreadySelectedCountry.countryCode ? false : true
        }

        cell.country = country
        setUpCellProperties(cell: cell)
        
        return cell
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sections.map {String($0)}
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return sections.firstIndex(of: Character(title))!
    }
}

// MARK: - Override SearchBar Delegate
extension CountryPickerWithSectionViewController {
    public override func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        super.searchBar(searchBar, textDidChange: searchText)
        if !searchText.isEmpty {
            searchHeaderTitle = searchText.first ?? "A"
        }
    }
}

// MARK: - TableViewDelegate
extension CountryPickerWithSectionViewController {
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch applySearch {
        case true:
            let country = filterCountries[indexPath.row]
            triggerCallbackAndDismiss(with: country)
        case false:
            var country: Country?
            if isFavoriteEnable {
                if indexPath.section == 0 {
                    country = favoriteCountries[indexPath.row]
                } else {
                    let character = sections[indexPath.section-1]
                    country = sectionCoutries[character]![indexPath.row]
                }
            } else {
                let character = sections[indexPath.section]
                country = sectionCoutries[character]![indexPath.row]
            }
            guard let _country = country else {
                #if DEBUG
                  print("fail to get country")
                #endif
                return
            }
            triggerCallbackAndDismiss(with: _country)
        }
     }
    
    private func triggerCallbackAndDismiss(with country: Country) {
        onSelectCountry?(country)
        manager.lastCountrySelected = country
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Array Extenstion
extension Array where Element: Equatable {
    func removeDuplicates() -> [Element] {
        var uniqueValues = [Element]()
        forEach {
            if !uniqueValues.contains($0) {
                uniqueValues.append($0)
            }
        }
        return uniqueValues
    }
}
