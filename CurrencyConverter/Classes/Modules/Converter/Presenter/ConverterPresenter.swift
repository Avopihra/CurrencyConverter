//
// CurrencyConverter
// Created by Viktoriya on 2023
// 
//

import Foundation
import UIKit

class ConverterPresenter: ConverterPresenterProtocol {
    
    weak var view: ConverterViewProtocol?
    var interactor: ConverterInteractorInputProtocol?
    var router: ConverterRouterProtocol?
    
    var baseCountryCode: String = ""
    var quoteCountryCode: String = ""
    
    init() {
        
    }
    
    // VIEW -> PRESENTER
    
    func didSelect(from type: CountryCodeType) {
       
        router?.showCurrencyListViewController()
    }
    
    func swapContryCodes(from base: inout String, to quote: inout String) {
        let temporaryValue = base
        base = quote
        quote = temporaryValue
        
        view?.setupCountryCode(base, for: .base)
        view?.setupCountryCode(quote, for: .quote)
    }
    
    func refresh() {
         
    }
    
    //MARK: - Private methods
    
}

extension ConverterPresenter: ConverterInteractorOutputProtocol {
    
    // INTERACTOR -> PRESENTER
    func setupCountryCode(code: String, for type: CountryCodeType) {
        view?.setupCountryCode(code, for: type)
    }
}
