//
// CurrencyCurrencyList
// Created by Viktoriya on 2023
// 
//

import Foundation
import UIKit

class CurrencyListWireFrame: CurrencyListWireFrameProtocol {
    
    var currencyListPresenter : CurrencyListPresenter?
    var converterPresenter : ConverterPresenter?
    
    var baseWireframe : BaseWireframe?
    var currencyListView : CurrencyListView?
    var currencyListWireFrame : CurrencyListWireFrame?
    var presenter: CurrencyListPresenterProtocol & CurrencyListInteractorOutputProtocol = CurrencyListPresenter()
    
    func presentCurrencyListModule(fromView window: AnyObject) {
        let currencyListView = currencyListModule()
    
        // Connecting
        currencyListView.presenter = currencyListPresenter
        currencyListPresenter?.view = currencyListView

        baseWireframe?.showRootViewController(currencyListView, window: window as! UIWindow)
    }
    
    func showCurrencyListViewController() {
        self.currencyListWireFrame?.presentCurrencyListModule(fromView: currencyListView!)
    }
    
    func currencyListModule() -> CurrencyListView {
        let viewController = CurrencyListView.loadFromNib()
        return viewController
    }
    
    func presentCurrencyListModule(fromView view: UIViewController) {
         
    }
    
    func dismissCurrencyListWithSelectedData(_ converterItem: CurrencyListItem) {
         
    }
}
