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
        
       dataManager?.fetchConversionRate(sourceCurrency: sourceCurrency, targetCurrency: targetCurrency, completion:  { result in
            switch result {
            case .success(let rate):
                completion(.success(rate))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
