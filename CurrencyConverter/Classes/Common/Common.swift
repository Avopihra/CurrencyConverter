//
//  Common.swift
//  CurrencyConverter
//
//  Created by Viktoriya on 30.05.2023.
//

import Foundation
import UIKit

final class Common {
    
    static func translate(_ key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
}
