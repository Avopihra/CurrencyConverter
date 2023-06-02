//
//  CachedConversionRate.swift
//  CurrencyConverter
//
//  Created by Viktoriya on 01.06.2023.
//

import UIKit
import CoreData

@objc(ConversionRate)
class ConversionRate: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ConversionRate> {
        return NSFetchRequest<ConversionRate>(entityName: "ConversionRate")
    }

    @NSManaged public var sourceCurrency: String?
    @NSManaged public var targetCurrency: String?
    @NSManaged public var rate: Double
    @NSManaged public var date: Date?
}

@objc(CurrencyList)
class CurrencyList: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrencyList> {
        return NSFetchRequest<CurrencyList>(entityName: "CurrencyList")
    }

    @NSManaged
    public var list: NSArray?
}

