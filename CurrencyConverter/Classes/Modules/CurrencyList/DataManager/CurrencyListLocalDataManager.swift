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
    
    func loadCurrencyListArrayFromCache(sourceCurrency: String?, targetCurrency: String?, completion: @escaping Common.CompletionHandler<[Currency]?>) {
        
        var error: Error?
        
        let semaphore = DispatchSemaphore(value: 0)
        var currencyList: [Currency] = []
        //Если кэш уже создан - достаем из контейнера и сортируем в зависимости от того, первая ли это итерация (известна ли хотя бы одна currency):
        dataManager?.fetchCurrencyList(sourceCurrency: sourceCurrency, targetCurrency: targetCurrency, completion: { result in
            switch result {
            case .success(let currencies):
                currencyList = currencies
            case .failure(let err):
                error = err
            }
        })
                
        guard !currencyList.isEmpty else {
            
            //Если еще нет кэша - отправляем запрос:
            var newCurrencyList: [Currency]?
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
                completion(.failure(error))
            }
            completion(.success(newCurrencyList))
            return
        }
        completion(.success(currencyList))
    }
}
