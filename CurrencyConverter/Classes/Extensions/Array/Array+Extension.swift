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
    
    func swapAndAppendHalves() -> [String] {
        let modifiedArray = self.map { element -> String in
            let halfIndex = element.index(element.startIndex, offsetBy: element.count / 2)
            let firstHalf = element[..<halfIndex]
            let secondHalf = element[halfIndex...]
            return String(secondHalf + firstHalf)
        }
        
        return self + modifiedArray
    }
}
