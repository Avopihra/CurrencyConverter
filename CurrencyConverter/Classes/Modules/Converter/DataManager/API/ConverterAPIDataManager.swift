//
// CurrencyConverter
// Created by Viktoriya on 2023
// 
//

import Foundation

class ConverterAPIDataManager: ConverterAPIDataManagerInputProtocol {
    
    private let dataManager: DataManager?
    
    init(_ dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    func convertCurrency(from sourceCurrency: String, to targetCurrency: String, date: Date?, completion: @escaping (Result<Double, Error>) -> Void) {
        dataManager?.convertCurrency(from: sourceCurrency, to: targetCurrency, date: date) { result in
            switch result {
            case .success(let rate):
                completion(.success(rate))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
