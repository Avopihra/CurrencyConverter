//
// CurrencyConverter
// Created by Viktoriya on 2023
// 
//

import Foundation
import UIKit

enum CurrencySide {
    case lhs
    case rhs
}

//MARK: - VIEW

protocol ConverterViewProtocol: AnyObject {
    var presenter: ConverterPresenterProtocol? { get set }
    
    // PRESENTER -> VIEW
    func updateValue()
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
    func didSelect(currency: Currency?, forSide side: CurrencySide)
    func swapTwoValues(from lhs: inout Currency, to rhs: inout Currency)
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
