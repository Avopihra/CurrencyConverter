//
//  UIFont+Extension.swift
//  CurrencyConverter
//
//  Created by Viktoriya on 01.06.2023.
//

import UIKit

extension UIFont {
    
    static func customFont(size: CGFloat = 17) -> UIFont {
        guard let font = UIFont(name: "OpenSans-Semibold", size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        
        return font
    }
}
