//
//  UINavigationBar.swift
//  CurrencyConverter
//
//  Created by Viktoriya on 01.06.2023.
//

import Foundation
import UIKit

extension UINavigationItem {
    
    func setTitle(text: String, font: UIFont = UIFont.customFont(), textColor: UIColor = .black) {
        let titleLabel = UILabel()
        titleLabel.text = text
        titleLabel.font = font
        titleLabel.textColor = textColor
        self.titleView = titleLabel
    }
}
