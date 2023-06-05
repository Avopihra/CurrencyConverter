//
// CurrencyCurrencyList
// Created by Viktoriya on 2023
// 
//

import Foundation
import UIKit

class CurrencyListRouter: CurrencyListRouterProtocol {
    
    var converterPresenter: ConverterPresenterProtocol?
    var baseRouter: BaseRouter?
    var presenter: CurrencyListPresenterProtocol & CurrencyListInteractorOutputProtocol = CurrencyListPresenter()
    
    private var currencyListView: CurrencyListView?
    private var presentedViewController : UIViewController?
    
    func currencyListModule(sourceCurrency: String?, targetCurrency: String?) -> UIViewController {
        let view = CurrencyListView.loadFromNib()
        presenter.view = view
        view.presenter = presenter
        view.sourceCurrency = sourceCurrency
        view.targetCurrency = targetCurrency
        return view
    }
    
    func push(from view: UIViewController, sourceCurrency: String?, targetCurrency: String?) {
        view.navigationController?.pushViewController(currencyListModule(sourceCurrency: sourceCurrency, targetCurrency: targetCurrency), animated: true)
    }
    
    func pop(from view: CurrencyListViewProtocol?, with countryCode: String) {
        self.converterPresenter?.returnCurrency(countryCode)
    }
}
