//
// CurrencyConverter
// Created by Viktoriya on 2023
// 
//

import Foundation
import UIKit

//MARK: - VIEW

protocol ConverterViewProtocol: AnyObject {
    var presenter: ConverterPresenterProtocol? { get set }
    
    // PRESENTER -> VIEW
    func setupCountryCode(_ code: String, for type: CountryCodeType)
    func updateCountryCode(_ code: String, for type: CountryCodeType)
    func updateOutput(value: String)
    func showError(message: String)
}

//MARK: - ROUTER

protocol ConverterRouterProtocol: AnyObject {
    func presentConverterModule(fromView window: AnyObject)
    func showCurrencyListViewController(sourceCurrency: String?, targetCurrency: String?)
    // PRESENTER -> ROUTER
    
}

//MARK: - PRESENTER

protocol ConverterPresenterProtocol: AnyObject {
    var view: ConverterViewProtocol? { get set }
    var interactor: ConverterInteractorInputProtocol? { get set }
    var router: ConverterRouterProtocol? { get set }
    
    //VIEW -> PRESENTER
    func convertValue(_ value: String, from sourceCurrency: String, to targetCurrency: String)
    func didSelect(from type: CountryCodeType, with code: String?)
    func setupCode(sourceCurrency: String?, targetCurrency: String?)
    func returnCurrency(_ currency: String)
    func swap(from source: inout String, to target: inout String)
}

//MARK: - INTERACTOR


    //MARK: - Interactor Output

protocol ConverterInteractorOutputProtocol: AnyObject {
    // INTERACTOR -> PRESENTER
    func valueConverted(_ value: String)
    func converteFailed(_ error: Error)
}

    //MARK: - Interactor Input

protocol ConverterInteractorInputProtocol: AnyObject {
    var presenter: ConverterInteractorOutputProtocol? { get set }
    // PRESENTER -> INTERACTOR
    func convertValue(_ value: String, from sourceCurrency: String, to targetCurrency: String)
}

//MARK: - DATA

    //MARK: - API DataManager

protocol ConverterDataManagerInputProtocol: AnyObject {
    // INTERACTOR -> APIDATAMANAGER
    func convertCurrency(from sourceCurrency: String, to targetCurrency: String, completion: @escaping (Result<Double, Error>) -> Void)
}
