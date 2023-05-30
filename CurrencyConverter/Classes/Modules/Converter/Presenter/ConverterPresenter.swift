//
// CurrencyConverter
// Created by Viktoriya on 2023
// 
//

import Foundation
import UIKit

class ConverterPresenter: ConverterPresenterProtocol {
    func didSelect(currencyPair: CurrencyPair) {
        <#code#>
    }
    
    func refresh() {
        <#code#>
    }
    
    func didUpdateValue(_ value: Double) {
        <#code#>
    }
    
    
    weak var view: ConverterViewProtocol?
    var interactor: ConverterInteractorInputProtocol?
    var router: ConverterRouterProtocol?
    
    private let lhsCurrency: Currency?
    private let rhsCurrency: Currency?
    
    init() {
        
    }
    
    // VIEW -> PRESENTER
    
    func didSelect(currency: Currency?, forSide side: CurrencySide) {
        switch side {
        case .lhs:
            lhsCurrency = currency
        case .rhs:
            rhsCurrency = currency
        }
        
        if let lhsCurrency = lhsCurrency, let rhsCurrency = rhsCurrency {
            let currencyPair = self.createCurrencyPair(from: lhsCurrency.code, to: rhsCurrency.code)
            
            presenter.didSelectCurrencyPair(currencyPair)
        }
    }
    
    func swapTwoValues(from lhs: inout Currency, to rhs: inout Currency) {
        let temporaryValue = lhs
        lhs = rhs
        rhs = temporaryValue
    }
    
    //MARK: - Private methods
    
    private func createCurrencyPair(from lhsCurrencyCode: String, to rhsCurrencyCode: String) -> CurrencyPair {
        let currencyPair = CurrencyPair(lhs: lhsCurrencyCode, rhs: rhsCurrencyCode)
        return currencyPair
    }
    
    private func updateConvertedValue() {
            guard let pair = selectedCurrencyPair else { return }
            let value = view?.getValue() ?? 0.0
            let convertedValue = value * conversionRate
            view?.updateConvertedValue(convertedValue)
            
            interactor.fetchConversionRate(for: pair) { [weak self] result in
                switch result {
                case .success(let rate):
                    self?.conversionRate = rate
                    let convertedValue = value * rate
                    self?.view?.updateConvertedValue(convertedValue)
                    
                case .failure(let error):
                    self?.view?.showError(error.localizedDescription)
                }
            }
        }

}

extension ConverterPresenter: ConverterInteractorOutputProtocol {
    
    // INTERACTOR -> PRESENTER

}
