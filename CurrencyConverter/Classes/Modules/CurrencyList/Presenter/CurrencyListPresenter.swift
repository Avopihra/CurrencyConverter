//
// CurrencyConverter
// Created by Viktoriya on 2023
// 
//

import Foundation

class CurrencyListPresenter: CurrencyListPresenterProtocol {
    
    weak var view: CurrencyListViewProtocol?
    var interactor: CurrencyListInteractorInputProtocol?
    var router: CurrencyListRouterProtocol?
    
    var currencyList: [Currency]?
    var rowCount: Int?
    
    init() {}
    
    // VIEW -> PRESENTER
    
    func loadCurrencyList(sourceCurrency: String?, targetCurrency: String?) {
        interactor?.loadCurrencyList(sourceCurrency: sourceCurrency, targetCurrency: targetCurrency)
    }
    
    func didSelectCell(at index: Int) {
        guard let currencyList = self.currencyList,
              !currencyList.isEmpty else {
            return
        }
        let currency = currencyList[index]
        router?.pop(from: view, with: currency.code)
    }
}

extension CurrencyListPresenter: CurrencyListInteractorOutputProtocol {
    
    // INTERACTOR -> PRESENTER
    
    func currencyListLoaded(_ currencyList: [Currency]) {
        self.rowCount = currencyList.count
        self.currencyList = currencyList
        self.view?.displayCurrencyList(currencyList)
    }
    
    func currencyListLoadFailed(_ error: Error) {
        self.view?.displayError(error.localizedDescription)
    }
}
