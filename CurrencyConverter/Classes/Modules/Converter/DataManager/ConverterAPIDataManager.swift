//
// CurrencyConverter
// Created by Viktoriya on 2023
// 
//

import Foundation

class ConverterDataManager: ConverterDataManagerInputProtocol {
    
    private let dataManager: DataManager?
    
    init(_ dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    func convertCurrency(from sourceCurrency: String, to targetCurrency: String, completion: @escaping (Result<Double, Error>) -> Void) {
        if let cachedValue = dataManager?.fetchCurrencyList(sourceCurrency: sourceCurrency, targetCurrency: targetCurrency) {
            print("CACHED: \(cachedValue)")
            
        }
        dataManager?.convertCurrency(from: sourceCurrency, to: targetCurrency) { result in
            switch result {
            case .success(let currency):
                completion(.success(currency))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
