//
// CurrencyConverter
// Created by Viktoriya on 2023
// 
//

import Foundation
import UIKit

protocol CurrencyListViewProtocol: AnyObject {
    var presenter: CurrencyListPresenterProtocol? { get set }
    // PRESENTER -> VIEW
    func displayCurrencyList(_ currencyList: [String])
    func displayError(_ message: String)
}

protocol CurrencyListRouterProtocol: AnyObject {
    func push(fromView view: UIViewController)
    func dismiss(view: UIViewController, with converterItem: String)
    //func dismissCurrencyListWithSelectedData(_ converterItem : String)
    // PRESENTER -> router
    
}

protocol CurrencyListPresenterProtocol: AnyObject {
    var view: CurrencyListViewProtocol? { get set }
    var interactor: CurrencyListInteractorInputProtocol? { get set }
    var router: CurrencyListRouterProtocol? { get set }
    // VIEW -> PRESENTER
    var currencyList: [String]? { get set }
    var rowCount: Int? { get set }
    func didSelectCell(at index: Int)
   // func didSelectCell(with data: String)
    func loadCurrencyList()
}

protocol CurrencyListInteractorOutputProtocol: AnyObject {
    // INTERACTOR -> PRESENTER
    func currencyListLoaded(_ currencyList: [String])
    func currencyListLoadFailed(_ error: Error)
}

protocol CurrencyListInteractorInputProtocol: AnyObject {
    var presenter: CurrencyListInteractorOutputProtocol? { get set }
    // PRESENTER -> INTERACTOR
    func loadCurrencyList()
}

protocol CurrencyListDataManagerInputProtocol: AnyObject {
    // INTERACTOR -> DATAMANAGER
}

protocol CurrencyListAPIDataManagerInputProtocol: AnyObject {
    // INTERACTOR -> APIDATAMANAGER
}

protocol CurrencyListLocalDataManagerInputProtocol: AnyObject {
    // INTERACTOR -> LOCALDATAMANAGER
    func loadCurrencyListArrayFromCache() -> [String]?
}
