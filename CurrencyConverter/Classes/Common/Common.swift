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
    
    static func checkTimeExpiration(_ interval: TimeInterval,
                                    completion: @escaping () -> Void) {
        guard let lastUpdated = UserDefaults.standard.object(forKey: "LastUpdated") as? Date else {
            completion()
            return
        }
        
        let currentDate = Date()
        let elapsedTime = currentDate.timeIntervalSince(lastUpdated)
        
        if elapsedTime >= interval {
            completion()
        } else {
            return
        }
    }
}
