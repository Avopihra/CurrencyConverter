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
    
    var persistentContainer: NSPersistentContainer?
    
    private let apiKey = "18c8986887bd18e492bb98a6b7e75b8f"
    private let baseURL = "https://currate.ru/api/"
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    // MARK: - API Requests
    
    func getCurrencyList(sourceCurrency: String?, targetCurrency: String?, completion: @escaping (Result<[String], Error>) -> Void) {
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
                self?.getRateList(currencyPairsList)
                let currencyList = currencyPairsList.splitAndSort()
                completion(.success(currencyList))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func getRateList(_ pairsList: [String]) {
        //https://currate.ru/api/?get=rates&pairs=USDRUB,EURRUB,USDGBP,USDBYN,GBPAUD&key=18c8986887bd18e492bb98a6b7e75b8f
        let joinedPairs = pairsList.joined(separator: ",")
        let urlString = "\(baseURL)?get=rates&pairs=\(joinedPairs)&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let error = error {
                print(error)
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
                print("RATE LIST: \(currencyPairsList)")
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
    
    func convertCurrency(from sourceCurrency: String,
                         to targetCurrency: String,
                         completion: @escaping (Result<Double, Error>) -> Void) {
        let urlString = "\(baseURL)?get=rates&pairs=\(sourceCurrency)\(targetCurrency)&key=\(apiKey)"
        print("API: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                completion(.failure(DataError.invalidURL))
            }
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(DataError.invalidData))
                }
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                guard let rates = json?["data"] as? [String: String],
                      let rate = rates[sourceCurrency+targetCurrency] else {
                    DispatchQueue.main.async {
                        completion(.failure(DataError.invalidResponse))
                    }
                    return
                }
                
                guard let conversionRate = Double(rate) else {
                    DispatchQueue.main.async {
                        completion(.failure(DataError.invalidConversionRate))
                    }
                    return
                }
                
                self?.saveConversionRate(sourceCurrency: sourceCurrency, targetCurrency: targetCurrency, rate: conversionRate)
                DispatchQueue.main.async {
                    completion(.success(conversionRate))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    // MARK: - Core Data Fetching support
    
    func fetchCurrencyList(sourceCurrency: String?, targetCurrency: String?) -> [String] {
        let fetchRequest: NSFetchRequest<CurrencyList> = CurrencyList.fetchRequest()
        
        guard let context = persistentContainer?.viewContext else {
            return []
        }
        
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
                return listForSpecificCurrency
            }
            
            //Это первая итерация (source и target неизвестны) - возвращаем все доступные значения из пар:
            let currencyList = currencyPairsList.splitAndSort()
            return currencyList
        } catch {
            print("Error fetching CurrencyList: \(error)")
            return []
        }
    }
  
    private func fetchConversionRate(completion: @escaping (Result<Double, Error>) -> Void) {
        let conversionRateFetchRequest: NSFetchRequest<ConversionRate> = ConversionRate.fetchRequest()
        do {
            let context = persistentContainer?.viewContext
            if let conversionRates = try context?.fetch(conversionRateFetchRequest) {
                for conversionRate in conversionRates {
                    let rate = conversionRate.rate
                    completion(.success(rate))
                }
            }
        } catch {
            print("Error fetching ConversionRate objects: \(error)")
            completion(.failure(DataError.invalidData))
        }
    }
    
    // MARK: - Core Data Saving support
    
    private func saveRateList(_ rateList: [String : String]) {
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
    
    private func saveConversionRate(sourceCurrency: String, targetCurrency: String, rate: Double) {
        persistentContainer?.performBackgroundTask { context in
            
            let conversionRate = ConversionRate(context: context)
            conversionRate.sourceCurrency = sourceCurrency
            conversionRate.targetCurrency = targetCurrency
            conversionRate.rate = rate
            
            do {
                try context.save()
            } catch {
                print("Failed to save conversion rate: \(error)")
            }
        }
    }
    
    private func saveCurrencyList(_ currencyList: [String]) {
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

