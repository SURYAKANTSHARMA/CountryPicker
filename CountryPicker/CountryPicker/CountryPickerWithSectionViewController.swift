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
    var sections: [Character] = []
    var sectionCoutries =  [Character: [Country]]()
    var searchHeaderTitle: Character = "A"

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

    func fetchSectionCountries() {
        sections = countries.map({ String($0.countryName.prefix(1)).first! }).removeDuplicates()
        
        for section in sections {
            let sectionCountries = countries.filter({ (country) -> Bool in
                return country.countryName.first! == section
            })
            sectionCoutries[section] = sectionCountries
        }
    }

    @discardableResult
    open override class func presentController(on viewController: UIViewController, callBack:@escaping (_ chosenCountry: Country) -> Void) -> CountryPickerWithSectionViewController {
        let controller = CountryPickerWithSectionViewController()
        controller.presentingVC = viewController
        controller.callBack = callBack
        let navigationController = UINavigationController(rootViewController: controller)
        //navigationController.navigationBar.barTintColor = UIColor.lightGray.withAlphaComponent(0.1)
        controller.presentingVC?.present(navigationController, animated: true, completion: nil)
        return controller
    }

}

// MARK: - TableView DataSource
extension CountryPickerWithSectionViewController {

    func numberOfSections(in tableView: UITableView) -> Int {
        return applySearch ? 1 : sections.count
    }
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return applySearch ? filterCountries.count : numberOfRowFor(section: section)
    }

    func numberOfRowFor(section: Int) -> Int {
        let character = sections[section]
        return sectionCoutries[character]!.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return applySearch ? String(searchHeaderTitle) : sections[section].description
    }
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CountryCell.reuseIdentifier) as? CountryCell {
            cell.accessoryType = .none
            cell.checkMarkImageView.isHidden = true

            let image = UIImage(named: "tickMark", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
            cell.checkMarkImageView.image = image

            var country: Country
            if applySearch {
                country = filterCountries[indexPath.row]
            } else {
                let character = sections[indexPath.section]
                country = sectionCoutries[character]![indexPath.row]
            }

            if let alreadySelectedCountry = CountryManager.shared.lastCountrySelected {
                cell.checkMarkImageView.isHidden = country.countryCode == alreadySelectedCountry.countryCode ? false: true
            }

            cell.country = country
            setUpCellProperties(cell: cell)
            return cell
        }
        fatalError("Cell with Identifier CountryTableViewCell cann't dequed")
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sections.map {String($0)}
    }
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return sections.index(of: Character(title))!
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
            self.callBack?(country)
            CountryManager.shared.lastCountrySelected = country
            self.dismiss(animated: false, completion: nil)
        case false:
            let character = sections[indexPath.section]
            let country = sectionCoutries[character]![indexPath.row]
            self.callBack?(country)
            CountryManager.shared.lastCountrySelected = country
        }
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
