//
// CurrencyCurrencyList
// Created by Viktoriya on 2023
// 
//

import Foundation
import UIKit

class CurrencyListRouter: CurrencyListRouterProtocol {
   
    //var currencyListPresenter : CurrencyListPresenter?
    var converterPresenter: ConverterPresenterProtocol?
    
    var baseRouter: BaseRouter?
    var currencyListView: CurrencyListView?
    //var currencyListRouter : CurrencyListRouter?
    var presenter: CurrencyListPresenterProtocol & CurrencyListInteractorOutputProtocol = CurrencyListPresenter()
    
    var presentedViewController : UIViewController?
    
    func presentCurrencyListModule(from window: AnyObject) {
        let view = currencyListModule() as! CurrencyListView
    
        // Connecting
        
        presenter.view = view
        currencyListView = view
        baseRouter?.showRootViewController(view, window: window as! UIWindow)
        presentedViewController = view
    }

    func currencyListModule() -> UIViewController {
        let view = CurrencyListView.loadFromNib()
        view.presenter = presenter
        return view
    }
    
    func push(from view: UIViewController) {
        view.navigationController?.pushViewController(currencyListModule(), animated: true)
    }
    
    func pop(from view: CurrencyListViewProtocol?, with countryCode: String) {
        self.converterPresenter?.returnCurrency(countryCode)
    }
}
