//
// CurrencyConverter
// Created by Viktoriya on 2023
// 
//

import UIKit
import CoreData

class CurrencyListLocalDataManager: CurrencyListLocalDataManagerInputProtocol {

    private let dataManager: DataManager?
    
    init(_ dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    func loadCurrencyListArrayFromCache() -> [String]? {
            var currencyList: [String]?
            var error: Error?
            
            let semaphore = DispatchSemaphore(value: 0)
            
            dataManager?.getCurrencyList { result in
                switch result {
                case .success(let currencies):
                    currencyList = currencies
                case .failure(let err):
                    error = err
                }
                
                semaphore.signal()
            }
            
            semaphore.wait()
            
            if let error = error {
                print("Error loading currency list from cache: \(error)")
                return nil
            }
            
            return currencyList
        }
}
