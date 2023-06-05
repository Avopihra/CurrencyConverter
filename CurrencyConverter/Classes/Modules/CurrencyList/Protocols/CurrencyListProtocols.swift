//
// CurrencyConverter
// Created by Viktoriya on 2023
// 
//

import Foundation
import UIKit

//MARK: - VIEW

protocol CurrencyListViewProtocol: AnyObject {
    var presenter: CurrencyListPresenterProtocol? { get set }
    func displayCurrencyList(_ currencyList: [Currency])
    func displayError(_ error: Error)
}

//MARK: - ROUTER

protocol CurrencyListRouterProtocol: AnyObject {
    func push(from view: UIViewController, sourceCurrency: String?, targetCurrency: String?)
    func pop(from view: CurrencyListViewProtocol?, with countryCode: String)
}

//MARK: - PRESENTER

protocol CurrencyListPresenterProtocol: AnyObject {
    var view: CurrencyListViewProtocol? { get set }
    var interactor: CurrencyListInteractorInputProtocol? { get set }
    var router: CurrencyListRouterProtocol? { get set }
    var currencyList: [Currency]? { get set }
    var rowCount: Int? { get set }
    func didSelectCell(at index: Int)
    func loadCurrencyList(sourceCurrency: String?, targetCurrency: String?)
}

//MARK: - INTERACTOR
//MARK: - Interactor Output

protocol CurrencyListInteractorOutputProtocol: AnyObject {
    func currencyListLoaded(_ currencyList: [Currency])
    func currencyListLoadFailed(_ error: Error)
}

//MARK: - Interactor Input

protocol CurrencyListInteractorInputProtocol: AnyObject {
    var presenter: CurrencyListInteractorOutputProtocol? { get set }
    func loadCurrencyList(sourceCurrency: String?, targetCurrency: String?)
}

//MARK: - DATA

protocol CurrencyListDataManagerInputProtocol: AnyObject {
    func loadCurrencyListArrayFromCache(sourceCurrency: String?, targetCurrency: String?, completion: @escaping Common.CompletionHandler<[Currency]?>)
}
