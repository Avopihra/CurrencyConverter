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
    
    func convertCurrency(from sourceCurrency: String, to targetCurrency: String, date: Date? = nil, completion: @escaping (Result<Double, Error>) -> Void) {
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
        print("REQUEST: \(urlString)")
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

                self?.saveCurrencyList(currencyList)
                
                completion(.success(currencyList))
            } catch {
                print("ERROR: \(DataError.invalidResponse)")
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
// MARK: - Core Data Saving support
    
    private func saveContext () {
        guard let context = persistentContainer?.viewContext else {
            return
        }
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    private func saveConversionRate(sourceCurrency: String, targetCurrency: String, rate: Double, date: Date?) {
     saveContext()
//        persistentContainer.performBackgroundTask { context in
//
//
//
//            let conversionRate = ConversionRate(context: context)
//            conversionRate.sourceCurrency = sourceCurrency
//            conversionRate.targetCurrency = targetCurrency
//            conversionRate.rate = rate
//            conversionRate.date = date
//
//            do {
//                try context.save()
//            } catch {
//                print("Failed to save conversion rate: \(error)")
//            }
//        }
    }
    
    private func saveCurrencyList(_ currencyList: [String]) {
        saveContext()
//        persistentContainer.performBackgroundTask { context in
//            let currencyListObject = CurrencyList(context: context)
//            currencyListObject.list = currencyList
//
//            do {
//                try context.save()
//            } catch {
//                print("Failed to save currency list: \(error)")
//            }
//        }
    }
}

