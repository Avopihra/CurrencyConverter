//
// CurrencyConverter
// Created by Viktoriya on 2023
// 
//

import Foundation

class CurrencyListPresenter: CurrencyListPresenterProtocol, CurrencyListInteractorOutputProtocol {
    weak var view: CurrencyListViewProtocol?
    var interactor: CurrencyListInteractorInputProtocol?
    var router: CurrencyListRouterProtocol?
    var rowsCount: Int {
        return 0 //currencySwrvice.getCurrncy.count
    }
    
    init() {}
    
}
