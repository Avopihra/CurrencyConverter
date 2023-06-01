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
    func updateOutput(value: String)
    func showError(message: String)
}

//MARK: - ROUTER

protocol ConverterRouterProtocol: AnyObject {
    func presentConverterModule(fromView window: AnyObject)
    func showCurrencyListViewController()
    
    // PRESENTER -> ROUTER
    
}

//MARK: - PRESENTER

protocol ConverterPresenterProtocol: AnyObject {
    var view: ConverterViewProtocol? { get set }
    var interactor: ConverterInteractorInputProtocol? { get set }
    var router: ConverterRouterProtocol? { get set }
    
    //VIEW -> PRESENTER
    func didSelect(from type: CountryCodeType)
    func swapContryCodes(from base: inout String, to quote: inout String)
    func refresh()
    
}

//MARK: - INTERACTOR


    //MARK: - Interactor Output

protocol ConverterInteractorOutputProtocol: AnyObject {
    // INTERACTOR -> PRESENTER
    
}

    //MARK: - Interactor Input

protocol ConverterInteractorInputProtocol: AnyObject {
    var presenter: ConverterInteractorOutputProtocol? { get set }
    // PRESENTER -> INTERACTOR
    
}

//MARK: - DATA

    //MARK: - DataManager


protocol ConverterDataManagerInputProtocol: AnyObject {
    // INTERACTOR -> DATAMANAGER
    
}

    //MARK: - API DataManager

protocol ConverterAPIDataManagerInputProtocol: AnyObject {
    // INTERACTOR -> APIDATAMANAGER
    
}

    //MARK: - Local DataManager

protocol ConverterLocalDataManagerInputProtocol: AnyObject {
    // INTERACTOR -> LOCALDATAMANAGER
    
}
