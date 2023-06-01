//
// CurrencyCurrencyList
// Created by Viktoriya on 2023
// 
//

import Foundation
import UIKit

class CurrencyListRouter: CurrencyListRouterProtocol {
    
    var currencyListPresenter : CurrencyListPresenter?
    var converterPresenter : ConverterPresenter?
    
    var baseRouter : BaseRouter?
    var currencyListView : CurrencyListView?
    var currencyListRouter : CurrencyListRouter?
    var presenter: CurrencyListPresenterProtocol & CurrencyListInteractorOutputProtocol = CurrencyListPresenter()
    
    func presentCurrencyListModule(fromView window: AnyObject) {
        let currencyListView = currencyListModule()
    
        // Connecting
        currencyListView.presenter = currencyListPresenter
        currencyListPresenter?.view = currencyListView

        baseRouter?.showRootViewController(currencyListView, window: window as! UIWindow)
    }
    
//    func showCurrencyListViewController() {
//        self.currencyListRouter?.presentCurrencyListModule(fromView: currencyListView!)
//    }
    
    func currencyListModule() -> CurrencyListView {
        let viewController = CurrencyListView.loadFromNib()
        return viewController
    }
    
    func presentCurrencyListModule(fromView view: UIViewController) {
        view.navigationController?.pushViewController(currencyListModule(), animated: true)
    }
    
    func dismissCurrencyListWithSelectedData(_ converterItem: Currency) {
         
    }
}
