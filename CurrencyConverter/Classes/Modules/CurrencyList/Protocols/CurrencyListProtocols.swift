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
    
}

protocol CurrencyListWireFrameProtocol: AnyObject {
    func presentCurrencyListModule(fromView view: UIViewController)
    func dismissCurrencyListWithSelectedData(_ converterItem : CurrencyListItem)
    // PRESENTER -> WIREFRAME
    
}

protocol CurrencyListPresenterProtocol: AnyObject {
    var view: CurrencyListViewProtocol? { get set }
    var interactor: CurrencyListInteractorInputProtocol? { get set }
    var wireFrame: CurrencyListWireFrameProtocol? { get set }
    // VIEW -> PRESENTER
}

protocol CurrencyListInteractorOutputProtocol: AnyObject {
    // INTERACTOR -> PRESENTER
    
}

protocol CurrencyListInteractorInputProtocol: AnyObject {
    var presenter: CurrencyListInteractorOutputProtocol? { get set }
    // PRESENTER -> INTERACTOR
}

protocol CurrencyListDataManagerInputProtocol: AnyObject {
    // INTERACTOR -> DATAMANAGER
}

protocol CurrencyListAPIDataManagerInputProtocol: AnyObject {
    // INTERACTOR -> APIDATAMANAGER
}

protocol CurrencyListLocalDataManagerInputProtocol: AnyObject {
    // INTERACTOR -> LOCALDATAMANAGER
}
