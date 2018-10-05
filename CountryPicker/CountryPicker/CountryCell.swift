//
//  CountryCell.swift
//  CountryCodeInSwift3
//
//  Created by cl-macmini-68 on 09/02/17.
//  Copyright © 2017 Suryakant. All rights reserved.
//

import UIKit

class CountryCell: UITableViewCell {

    // MARK: - Variables
    static let reuseIdentifier = String(describing: CountryCell.self)

    let checkMarkImageView: UIImageView = {
       let imageView = UIImageView()
       imageView.translatesAutoresizingMaskIntoConstraints = false
       imageView.contentMode = .scaleAspectFit
       return imageView
    }()

    let nameLabel: UILabel = {
       let label = UILabel()
       label.translatesAutoresizingMaskIntoConstraints = false
       return label
    }()

    let diallingCodeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let separatorLineView: UIView = {
       let view = UIView()
       view.backgroundColor = UIColor.gray
       view.translatesAutoresizingMaskIntoConstraints = false
       return view
    }()

    let flagImageView: UIImageView = {
       let imageView = UIImageView()
       imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
    }()

    // MARK: - Model
    var country: Country! {
        didSet {
            nameLabel.text = country.countryName
            diallingCodeLabel.text = country.dialingCode
            flagImageView.image = country.flag
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setUpView()
    }

    // MARK: - View SetUp
    private func setUpView() {
        setUpFlagImageView()
        setUpLabels()
        setUpSepratorView()
        setUpCheckMarkImageView()
    }

    private func setUpFlagImageView() {
        addSubview(flagImageView)
        if #available(iOS 11.0, *) {
            flagImageView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 8).isActive = true
            flagImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        } else {
            flagImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
            flagImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        }
        flagImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        flagImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }

    private func setUpLabels() {
        addSubview(nameLabel)
        addSubview(diallingCodeLabel)

        nameLabel.topAnchor.constraint(equalTo: flagImageView.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: flagImageView.rightAnchor, constant: 8).isActive = true

        diallingCodeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        diallingCodeLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
    }

    private func setUpSepratorView() {
        addSubview(separatorLineView)

        separatorLineView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separatorLineView.leftAnchor.constraint(equalTo: diallingCodeLabel.leftAnchor).isActive = true
        separatorLineView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true

    }

    private func setUpCheckMarkImageView() {
        addSubview(checkMarkImageView)

        checkMarkImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        checkMarkImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        checkMarkImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        checkMarkImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
    }

}
