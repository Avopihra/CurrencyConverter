//
//  ReferenceManager.swift
//  CurrencyConverter
//
//  Created by Viktoriya on 30.05.2023.
//

import UIKit

 final class ReferenceManager {
    
    static func sourceStringURL(size: Int, text: String) -> String {
        let source = "https://currate.ru/api/"
        let textGet = "?get="
        let currency_list = "currency_list"
        let rates_pairs = "rates&pairs"
        let textKey = "&key="
        let APIKey = "18c8986887bd18e492bb98a6b7e75b8f"
        let API = source + textGet + currency_list + textKey + APIKey
        return API
    }
}
