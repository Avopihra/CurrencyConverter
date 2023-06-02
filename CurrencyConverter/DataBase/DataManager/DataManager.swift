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
    
    func convertCurrency(from sourceCurrency: String,
                         to targetCurrency: String,
                         date: Date? = nil,
                         completion: @escaping (Result<Double, Error>) -> Void) {
        
        let dateString = date?.formatDate() ?? ""
        let urlString = "\(baseURL)?get=rates&pairs=\(sourceCurrency)\(targetCurrency)&date=\(dateString)&key=\(apiKey)"
        
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
                guard let rates = json?["data"] as? [String: String],
                      let rate = rates[targetCurrency] else {
                    completion(.failure(DataError.invalidResponse))
                    return
                }
                
                guard let conversionRate = Double(rate) else {
                    completion(.failure(DataError.invalidConversionRate))
                    return
                }
                
                self?.saveConversionRate(sourceCurrency: sourceCurrency, targetCurrency: targetCurrency, rate: conversionRate, date: date)
                
                completion(.success(conversionRate))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func getCurrencyList(completion: @escaping (Result<[String], Error>) -> Void) {
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
                guard let currencyList = json?["data"] as? [String] else {
                    print("ERROR: \(DataError.invalidResponse)")
                    completion(.failure(DataError.invalidResponse))
                    return
                }
                print("DATA: \(currencyList)")
                var uniqueCurrencyList = Set<String>()
                for element in currencyList {
                    let part1 = String(element.prefix(3))
                    let part2 = String(element.suffix(3))
                    
                    uniqueCurrencyList.insert(part1)
                    uniqueCurrencyList.insert(part2)
                }
                let result = Array(uniqueCurrencyList).sorted(by: <)
                print("UNIQUE DATA: \(result)")
                self?.saveCurrencyList(result)
                
                completion(.success(result))
            } catch {
                print("ERROR: \(DataError.invalidResponse)")
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
// MARK: - Core Data Fetching support
    private func fetchConversionRate(completion: @escaping (Result<Double, Error>) -> Void) {
        let conversionRateFetchRequest: NSFetchRequest<ConversionRate> = ConversionRate.fetchRequest()
        do {
            let context = persistentContainer?.viewContext
            if let conversionRates = try context?.fetch(conversionRateFetchRequest) {
                for conversionRate in conversionRates {

                    let sourceCurrency = conversionRate.sourceCurrency
                    let targetCurrency = conversionRate.targetCurrency
                    let rate = conversionRate.rate
                    let date = conversionRate.date
                    
                    completion(.success(rate))
                }
            }
        } catch {
            print("Error fetching ConversionRate objects: \(error)")
            completion(.failure(DataError.invalidData))
        }
    }
    
    func fetchCurrencyList() -> [String] {
        let fetchRequest: NSFetchRequest<CurrencyList> = CurrencyList.fetchRequest()
        do {
            let context = persistentContainer?.viewContext
            if let results = try context?.fetch(fetchRequest) {
                var currencies: [String] = []
                for currencyListObj in results {
                    if let currencyList = currencyListObj.list as? [String] {
                        currencies.append(contentsOf: currencyList)
                    }
                }
                return currencies
            }
            return []
        } catch {
            print("Error fetching CurrencyList: \(error)")
            return []
        }
    }
    
// MARK: - Core Data Saving support

    private func saveConversionRate(sourceCurrency: String, targetCurrency: String, rate: Double, date: Date?) {
        persistentContainer?.performBackgroundTask { context in

            let conversionRate = ConversionRate(context: context)
            conversionRate.sourceCurrency = sourceCurrency
            conversionRate.targetCurrency = targetCurrency
            conversionRate.rate = rate
            conversionRate.date = date

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

