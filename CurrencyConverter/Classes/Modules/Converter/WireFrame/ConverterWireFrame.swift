//
// CurrencyConverter
// Created by Viktoriya on 2023
// 
//

import Foundation
import UIKit

class ConverterWireFrame: ConverterWireFrameProtocol {
    var baseWireframe : BaseWireframe?
    var converterView : ConverterView?
    var currencyListWireFrame : CurrencyListWireFrame?
    var presenter: ConverterPresenterProtocol & ConverterInteractorOutputProtocol = ConverterPresenter()
    
    func presentConverterModule(fromView window: AnyObject) {
        let view = converterModule() as! ConverterView
        
        // Connecting
        
        presenter.view = view
        converterView = view
        baseWireframe?.showRootViewController(view, window: window as! UIWindow)
    }
    
    func showCurrencyListViewController() {
        self.currencyListWireFrame?.presentCurrencyListModule(fromView: converterView!)
    }
    
    func converterModule() -> UIViewController {
        let view = ConverterView.loadFromNib()
        view.presenter = presenter
        return view
    }
}


