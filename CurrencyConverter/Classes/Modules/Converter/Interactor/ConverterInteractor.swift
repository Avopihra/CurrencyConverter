//
// CurrencyConverter
// Created by Viktoriya on 2023
// 
//

import Foundation

class ConverterInteractor: ConverterInteractorInputProtocol {
    weak var presenter: ConverterInteractorOutputProtocol?
    
    private let apiDataManager: ConverterDataManagerInputProtocol
    
    init(dataManager: ConverterDataManagerInputProtocol) {
        self.apiDataManager = dataManager
    }
    
    // PRESENTER -> INTERACTOR
    
    func convertValue(_ value: String, from sourceCurrency: String, to targetCurrency: String) {
        apiDataManager.convertCurrency(from: sourceCurrency, to: targetCurrency) { result in
            switch result {
            case .success(let k):
                if let doubleValue = Double(value) {
                    let newValue = doubleValue*k
                    self.presenter?.valueConverted("\(newValue)")
                }
            case .failure(let error):
               self.presenter?.converteFailed(error)
            }
        }
    }
}
