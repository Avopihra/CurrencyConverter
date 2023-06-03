//
// CurrencyConverter
// Created by Viktoriya on 2023
// 
//

import Foundation
import UIKit

class ConverterRouter: ConverterRouterProtocol {
    
    var baseRouter : BaseRouter?
    var converterView : ConverterView?
    var currencyListRouter : CurrencyListRouter?
    var presenter: ConverterPresenterProtocol & ConverterInteractorOutputProtocol = ConverterPresenter()
    
    func presentConverterModule(fromView window: AnyObject) {
        let view = converterModule() as! ConverterView
        
        // Connecting
        
        presenter.view = view
        converterView = view
        baseRouter?.showRootViewController(view, window: window as! UIWindow)
    }
    
    func showCurrencyListViewController(sourceCurrency: String?, targetCurrency: String?) {
        self.currencyListRouter?.push(from: converterView!, sourceCurrency: sourceCurrency, targetCurrency: targetCurrency)
    }
    
    func converterModule() -> UIViewController {
        let view = ConverterView.loadFromNib()
        view.presenter = presenter
        return view
    }
}


