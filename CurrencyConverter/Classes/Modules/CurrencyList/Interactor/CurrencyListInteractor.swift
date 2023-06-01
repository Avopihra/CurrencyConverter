//
// CurrencyConverter
// Created by Viktoriya on 2023
// 
//

import Foundation

class CurrencyListInteractor: CurrencyListInteractorInputProtocol {
    weak var presenter: CurrencyListInteractorOutputProtocol?
    private let localDataManager: CurrencyListLocalDataManagerInputProtocol
    
    init(dataManager: CurrencyListLocalDataManagerInputProtocol) {
        self.localDataManager = dataManager
    }
    
    func loadCurrencyList() {
           if let currencyList = localDataManager.loadCurrencyListArrayFromCache() {
               presenter?.currencyListLoaded(currencyList)
           } else {
               let error = NSError(domain: "com.example.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to load currency list."])
               presenter?.currencyListLoadFailed(error)
           }
       }
    
}
