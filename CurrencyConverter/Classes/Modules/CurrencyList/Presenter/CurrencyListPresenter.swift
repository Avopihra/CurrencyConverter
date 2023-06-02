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
    
    var currencyList: [String]?
    var rowCount: Int?
    
        
    init() {}
    
    // VIEW -> PRESENTER

    func loadCurrencyList() {
        guard let currencyList = self.currencyList,
                 !currencyList.isEmpty else {
            interactor?.loadCurrencyList()
            return
        }
        self.view?.displayCurrencyList(currencyList)
    }

    func didSelectCell(at index: Int) {
        guard let currencyList = self.currencyList,
                !currencyList.isEmpty else {
            return
        }
        let currency = currencyList[index]
        router?.pop(from: view, with: currency)
    }
}

extension CurrencyListPresenter: CurrencyListInteractorOutputProtocol {
    
    // INTERACTOR -> PRESENTER

    func currencyListLoaded(_ currencyList: [String]) {
        self.rowCount = currencyList.count
        self.currencyList = currencyList
    }
    
    func currencyListLoadFailed(_ error: Error) {
        self.view?.displayError(error.localizedDescription)
    }
}
