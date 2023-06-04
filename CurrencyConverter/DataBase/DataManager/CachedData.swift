//
//  CachedConversionRate.swift
//  CurrencyConverter
//
//  Created by Viktoriya on 01.06.2023.
//

import UIKit
import CoreData

@objc(RateList)

class RateList: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<RateList> {
            return NSFetchRequest<RateList>(entityName: "RateList")
        }
    @NSManaged
    var rateDictionary: [String: String]
}

@objc(CurrencyList)
class CurrencyList: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrencyList> {
        return NSFetchRequest<CurrencyList>(entityName: "CurrencyList")
    }

    @NSManaged
    public var list: NSArray?
}

