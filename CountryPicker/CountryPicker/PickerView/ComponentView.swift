//
//  ComponentView.swift
//  CountryPicker
//
//  Created by Hardeep Singh on 13/12/19.
//  Copyright © 2019 SuryaKant Sharma. All rights reserved.
//

import UIKit

// Mark:- Component View
internal class ComponentView: UIView {
    
    private(set) var imageView: UIImageView = UIImageView()
    private(set) var countryNameLabel: UILabel = UILabel()
    private(set) var diallingCodeLabel: UILabel = UILabel()
    
    var padding: CGFloat = 0.0
    
    private(set) var maxWdith: CGFloat = 0.09
    override init(frame: CGRect) {
        
        super.init(frame: frame)

        // Image View
        imageView.tag = 101
        imageView.layer.cornerRadius = 5.0
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        self.addSubview(imageView)
        
        // Label
        countryNameLabel.tag = 102
        countryNameLabel.text = "United State"
        countryNameLabel.textColor = .black
        countryNameLabel.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(countryNameLabel)
        
        // Label
        diallingCodeLabel.tag = 103
        diallingCodeLabel.textColor = .darkGray
        diallingCodeLabel.font = UIFont.systemFont(ofSize: 11)
        self.addSubview(diallingCodeLabel)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Cell Size
        let height = self.frame.size.height
        //let width = self.frame.size.width
        
        // Image Size
        let imageSize = (height - (padding * 2))
        let imageViewFrame = CGRect(x: padding, y: padding, width: imageSize, height: imageSize)
        self.imageView.frame = imageViewFrame
        
        // CountryName Label Size
        let x = imageViewFrame.maxX + 5
        var y: CGFloat = 0.0
        let paddingWidth = self.frame.size.width - (imageViewFrame.maxX + (padding * 2))
        
        let labelMaxSize = CGSize(width: paddingWidth, height: (height - 10) / 2.0)
        let countryNameSize = countryNameLabel.sizeThatFits(labelMaxSize)
       
        let diallingCodeSize = diallingCodeLabel.sizeThatFits(labelMaxSize)
        y = max((height - (countryNameSize.height + diallingCodeSize.height)) / 2.0, 0.0)
        
        let countryNameLabelFrame = CGRect(x: x, y: y, width: countryNameSize.width, height: countryNameSize.height)
        countryNameLabel.frame = countryNameLabelFrame
        
        y += countryNameSize.height
        let diallingCodeLabelFrame = CGRect(x: x, y: y, width: diallingCodeSize.width, height: diallingCodeSize.height)
        diallingCodeLabel.frame = diallingCodeLabelFrame
        
        let maxWidthRequired = countryNameSize.width + (padding * 2) + imageSize
        maxWdith = maxWidthRequired
    }
    
}

extension Country: Equatable {
    public static func ==(lhs: Country, rhs: Country) -> Bool {
        return (lhs.countryCode == rhs.countryCode && lhs.dialingCode == rhs.dialingCode)
    }
}

