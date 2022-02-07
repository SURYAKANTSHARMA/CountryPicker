//
//  UIViewControllerHelpers.swift
//  CountryPickerTests
//
//  Created by Github on 08/01/21.
//  Copyright © 2021 SuryaKant Sharma. All rights reserved.
//

import UIKit

extension UIViewController {
    func startLifeCycle() {
        _ = view
        view.setNeedsLayout()
        view.layoutIfNeeded()
        beginAppearanceTransition(true, animated: true)
    }
}
