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
        if let currencyList = localDataManager.loadCurrencyListArrayFromCache(sourceCurrency: sourceCurrency, targetCurrency: targetCurrency) {
               presenter?.currencyListLoaded(currencyList)
           } else {
               let error = NSError(domain: "https://currate.ru/api/", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to load currency list."])
               presenter?.currencyListLoadFailed(error)
           }
       }
}
