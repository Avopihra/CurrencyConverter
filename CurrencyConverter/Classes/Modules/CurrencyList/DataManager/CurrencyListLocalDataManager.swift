//
// CurrencyConverter
// Created by Viktoriya on 2023
// 
//

import UIKit
import CoreData

class CurrencyListDataManager: CurrencyListDataManagerInputProtocol {
    
    private let dataManager: DataManager?
    
    init(_ dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    func loadCurrencyListArrayFromCache(sourceCurrency: String?, targetCurrency: String?) -> [String]? {
        
        var error: Error?
        
        let semaphore = DispatchSemaphore(value: 0)
        
        //Если кэш уже создан - достаем из контейнера и сортируем в зависимости от того, первая ли это итерация (известна ли хотя бы одна currency):
        guard let currencyList = dataManager?.fetchCurrencyList(sourceCurrency: sourceCurrency,
                                                                targetCurrency: targetCurrency),
              !currencyList.isEmpty else {
            
            //Если еще нет кэша - отправляем запрос:
            var newCurrencyList: [String]?
            dataManager?.getCurrencyList(sourceCurrency: sourceCurrency,
                                         targetCurrency: targetCurrency, completion: { result in
                switch result {
                case .success(let currencies):
                    newCurrencyList = currencies
                case .failure(let err):
                    error = err
                }
                
                semaphore.signal()
            })
            
            semaphore.wait()
            
            if let error = error {
                print("Error loading currency list from cache: \(error)")
                return nil
            }
            return newCurrencyList
        }
        return currencyList
    }
}
