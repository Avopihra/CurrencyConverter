//
// CurrencyConverter
// Created by Viktoriya on 2023
// 
//

import Foundation

class CurrencyListInteractor: CurrencyListInteractorInputProtocol {
    weak var presenter: CurrencyListInteractorOutputProtocol?
    private let localDataManager: CurrencyListDataManagerInputProtocol
    
    init(dataManager: CurrencyListDataManagerInputProtocol) {
        self.localDataManager = dataManager
    }
    
    func loadCurrencyList(sourceCurrency: String?, targetCurrency: String?) {
        localDataManager.loadCurrencyListArrayFromCache(sourceCurrency: sourceCurrency, targetCurrency: targetCurrency) { result in
            switch result {
            case .success(let currency):
                if let list = currency {
                    self.presenter?.currencyListLoaded(list)
                } else {
                    self.presenter?.currencyListLoadFailed(ErrorHandling.invalidData)
                }
            case .failure(let error):
                DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1, execute: {
                    self.presenter?.currencyListLoadFailed(error)
                })
            }
        }
    }
}
