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
    
    var selectedType: CountryCodeType = .source
    
    init() {}
    
    // VIEW -> PRESENTER
    
    func didSelect(from type: CountryCodeType) {
        self.selectedType = type
        router?.showCurrencyListViewController()
    }
    
    func swapContryCodes(from source: inout String, to target: inout String) {
        let temporaryValue = source
        source = target
        target = temporaryValue
        
        view?.setupCountryCode(source, for: .source)
        view?.setupCountryCode(target, for: .target)
    }
    
    func refresh() {
         
    }
    
    func returnCurrency(_ currency: String) {
        view?.setupCountryCode(currency, for: selectedType)
    }
    
    //MARK: - Private methods
    
}

extension ConverterPresenter: ConverterInteractorOutputProtocol {
    
    // INTERACTOR -> PRESENTER
    func setupCountryCode(code: String, for type: CountryCodeType) {
        view?.setupCountryCode(code, for: type)
    }
}
