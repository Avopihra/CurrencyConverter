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
    
    private var selectedType: CountryCodeType = .source
    private var sourceCurrency: String?
    private var targetCurrency: String?
    
    init() {}
    
    // VIEW -> PRESENTER
    
    func convertValue(_ value: String, from sourceCurrency: String, to targetCurrency: String) {
        interactor?.convertValue(value, from: sourceCurrency, to: targetCurrency)
    }
    
    func didSelect(from type: CountryCodeType, with code: String?) {
        self.selectedType = type
        switch type {
        case .source:
            self.sourceCurrency = code
        case .target:
            self.targetCurrency = code
        }
        router?.showCurrencyListViewController(sourceCurrency: sourceCurrency, targetCurrency: targetCurrency)
    }
    
    func setupCode(sourceCurrency: String?, targetCurrency: String?) {
        self.sourceCurrency = sourceCurrency
        self.targetCurrency = targetCurrency  
    }
    
    func swap(from source: inout String, to target: inout String) {
        let temporaryValue = source
        source = target
        self.sourceCurrency = target
        target = temporaryValue
        self.targetCurrency = temporaryValue
        view?.updateCountryCode(source, for: .source)
        view?.updateCountryCode(target, for: .target)
    }
    
    func returnCurrency(_ currency: String) {
        view?.setupCountryCode(currency, for: selectedType)
    }
}

extension ConverterPresenter: ConverterInteractorOutputProtocol {
    func valueConverted(_ value: String) {
        view?.updateOutput(value: value)
    }
    
    func converteFailed(_ error: Error) {
        view?.showError(message: Common.translate("Error.SomethingWentWrong"))
    }
    
    // INTERACTOR -> PRESENTER
    func setupCountryCode(code: String, for type: CountryCodeType) {
        view?.setupCountryCode(code, for: type)
    }
}
