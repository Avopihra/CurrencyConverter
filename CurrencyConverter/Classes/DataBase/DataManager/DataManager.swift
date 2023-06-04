//
//  DataManager.swift
//  CurrencyConverter
//
//  Created by Viktoriya on 01.06.2023.
//

import Foundation
import CoreData
import UIKit

// MARK: - Error Handling
enum DataError: Error {
    case invalidURL
    case invalidData
    case invalidResponse
    case invalidConversionRate
}

class DataManager {
    
    typealias CompletionHandler<T> = (Result<T, Error>) -> Void
    
    var persistentContainer: NSPersistentContainer?
    
    private let apiKey = "18c8986887bd18e492bb98a6b7e75b8f"
    private let baseURL = "https://currate.ru/api/"
    private let interval: TimeInterval = 24*60*60
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    // MARK: - API Requests
    
    func getCurrencyList(sourceCurrency: String?, targetCurrency: String?, completion: @escaping CompletionHandler<[Currency]>) {
        let urlString = "\(baseURL)?get=currency_list&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(DataError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(DataError.invalidData))
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                guard let currencyPairsList = json?["data"] as? [String] else {
                    completion(.failure(DataError.invalidResponse))
                    return
                }
                
                self?.saveCurrencyList(currencyPairsList)
                self?.getRateList(currencyPairsList.swapAndAppendHalves())
                
                let currencyList = currencyPairsList.splitAndSort()
                completion(.success(currencyList.map { Currency(code: $0) }))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    //MARK: - RateList
    
    func getRateList(_ pairsList: [String]) {
        let joinedPairs = pairsList.joined(separator: ",")
        let urlString = "\(baseURL)?get=rates&pairs=\(joinedPairs)&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                guard let currencyPairsList = json?["data"] as? [String:String] else {
                    return
                }
                
                self?.saveRateList(currencyPairsList)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
    
    
    // MARK: - Core Data Fetching support
    
    func fetchCurrencyList(sourceCurrency: String?, targetCurrency: String?) -> [Currency] {
        let fetchRequest: NSFetchRequest<CurrencyList> = CurrencyList.fetchRequest()
        
        guard let context = persistentContainer?.viewContext else {
            return []
        }
        self.cleanCache(interval: interval, context: context, entityName: CurrencyList.description(), completion: {
            self.getCurrencyList(sourceCurrency: sourceCurrency, targetCurrency: targetCurrency, completion: { _ in })
        })
        do {
            //Достаем из контейнера currencyPairsList:
            let cachedArrayOfCurrencyPairsList = try context.fetch(fetchRequest)
            let currencyPairsList = cachedArrayOfCurrencyPairsList.compactMap { $0.list as? [String] }
                .flatMap { $0 }
            
            //Проверяем, первая ли это итерация (известна хотя бы одна currency):
            if let source = sourceCurrency,
               let target = targetCurrency,
               (!source.isEmpty || !target.isEmpty) {
                //Известна хотя бы одна currency - оставляем в парах только пересекающиеся значения:
                let intersectingPairs = currencyPairsList.filter { $0.contains(source) || $0.contains(target) }
                //Делим пересекающиеся элементы пополам и удаляем саму currency:
                let listForSpecificCurrency = intersectingPairs.splitAndSort()
                    .filter { !$0.contains(source) && !$0.contains(target) }
                return listForSpecificCurrency.map{Currency(code: $0)}
            }
            
            //Это первая итерация (source и target неизвестны) - возвращаем все доступные значения из пар:
            let currencyList = currencyPairsList.splitAndSort()
            return currencyList.map{Currency(code: $0)}
        } catch {
            print("Error fetching CurrencyList: \(error)")
            return []
        }
    }
    
    func fetchConversionRate(sourceCurrency: String?, targetCurrency: String?, completion: @escaping CompletionHandler<Double>) {
        let rateListFetchRequest: NSFetchRequest<RateList> = RateList.fetchRequest()
        do {
            guard let context = persistentContainer?.viewContext else {
                return
            }
            self.cleanCache(interval: interval, context: context, entityName: RateList.description(), completion:  {
                self.getCurrencyList(sourceCurrency: sourceCurrency, targetCurrency: targetCurrency, completion: { _ in })
            })
            
            let cachedRateList = try context.fetch(rateListFetchRequest)
            let currencyPair = (sourceCurrency ?? "") + (targetCurrency ?? "")
            
            for rateList in cachedRateList {
                guard let exchangeRateString = rateList.rateDictionary[currencyPair],
                      let exchangeRate = Double(exchangeRateString) else {
                    
                    completion(.failure(DataError.invalidConversionRate))
                    return
                }
                completion(.success(exchangeRate))
            }
        } catch {
            print("Error fetching ConversionRate: \(error)")
            completion(.failure(DataError.invalidData))
        }
    }
}

// MARK: - Core Data Saving support

private extension DataManager {
    
    func saveRateList(_ rateList: [String : String]) {
        guard let context = persistentContainer?.viewContext else {
            return
        }
        
        let dictionaryEntity = RateList(context: context)
        dictionaryEntity.rateDictionary = rateList
        
        do {
            try context.save()
        } catch {
            print("Error saving dictionary: \(error)")
        }
    }
    
    func saveCurrencyList(_ currencyList: [String]) {
        persistentContainer?.performBackgroundTask { context in
            let currencyListObj = CurrencyList(context: context)
            currencyListObj.list = currencyList as NSArray
            
            do {
                try context.save()
            } catch {
                print("Failed to save currency list: \(error)")
            }
        }
    }
}

//MARK: - Core Data Cleaning Support

private extension DataManager {
    
    func cleanCache(interval: TimeInterval, context: NSManagedObjectContext, entityName: String, completion: @escaping () -> Void) {
        
        let userDefaults = UserDefaults.standard
        let lastCleanupDate = userDefaults.object(forKey: "LastCleanupDate") as? Date
        
        guard let lastDate = lastCleanupDate else {
            saveLastCleanupDate(completion: {})
            return
        }
        
        let currentDate = Date()
        
        if currentDate.timeIntervalSince(lastDate) >= interval {
            self.cleanCoreDataCache(context: context, entityName: entityName)
            self.saveLastCleanupDate(completion: completion)
        } else {
            return
        }
    }
    
    func cleanCoreDataCache(context: NSManagedObjectContext, entityName: String) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            try context.save()
            print("CACHE: The cache was successfully cleared! The next iteration will update the data from the server")
        } catch {
            print("Failed to clean CoreData cache: \(error)")
        }
    }
    
    func saveLastCleanupDate(completion: @escaping () -> Void) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(Date(), forKey: "LastCleanupDate")
        userDefaults.synchronize()
        completion()
    }
}
