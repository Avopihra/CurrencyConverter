//
//  Array+Extension.swift
//  CurrencyConverter
//
//  Created by Viktoriya on 03.06.2023.
//

import Foundation

extension Array where Element == String {
    func splitAndSort() -> [String] {
        var result: [String] = []
        
        for element in self {
            let halfLength = element.count / 2
            let firstHalf = String(element.prefix(halfLength))
            let secondHalf = String(element.suffix(halfLength))
            
            result.append(firstHalf)
            result.append(secondHalf)
        }
        
        let uniqueElements = Array(Set(result)).sorted(by: <)
        return uniqueElements
    }
}
