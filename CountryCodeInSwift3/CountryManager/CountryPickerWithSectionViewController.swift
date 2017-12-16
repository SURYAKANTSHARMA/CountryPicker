//
//  CountryPickerWithSectionViewController.swift
//  CountryCodeInSwift3
//
//  Created by SuryaKant Sharma on 16/12/17.
//  Copyright © 2017 Suryakant. All rights reserved.
//

import UIKit

class CountryPickerWithSectionViewController: CountryPickerController {
    //MARK:- Variables
    var sections: [Character] = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    var sectionCoutries =  [Character: [Country]]()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = nil
        tableView.delegate = nil
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchSectionCountries()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func fetchSectionCountries() {
        for section in sections {
            let sectionCountries = countries.filter({ (country) -> Bool in
                return country.countryName.first! == section
            })
            sectionCoutries[section] = sectionCountries
        }
    }
}

//MARK:- TableView DataSource
extension CountryPickerWithSectionViewController  {
    func numberOfSections(in tableView: UITableView) -> Int {
        return applySearch ? 1 : sections.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return applySearch ? filterCountries.count : numberOfRowFor(section: section)
    }
    
    func numberOfRowFor(section: Int) -> Int {
        let character = sections[section]
        return sectionCoutries[character]!.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].description
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTableViewCell") as? CountryTableViewCell {
            cell.accessoryType = .none
            cell.checkmarkImageView.isHidden = true
            
            let image = UIImage(named: "tickMark")!.withRenderingMode(.alwaysTemplate)
            cell.checkmarkImageView.image = image
            
            var country: Country
            if applySearch {
                country = filterCountries[indexPath.row]
            } else {
                let character = sections[indexPath.section]
                country = sectionCoutries[character]![indexPath.row]
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
        fatalError("Cell with Identifier CountryTableViewCell cann't dequed")
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sections.map{String($0)}
    }
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return sections.index(of: Character(title))!
    }
}

//MARK:- TableViewDelegate
extension CountryPickerWithSectionViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch applySearch {
        case true:
            let country = filterCountries[indexPath.row]
            self.callBack?(country)
            CountryManager.shared.lastCountrySelected = country
        case false:
            let character = sections[indexPath.section]
            let country = sectionCoutries[character]![indexPath.row]
            self.callBack?(country)
            CountryManager.shared.lastCountrySelected = country
        }
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
}
