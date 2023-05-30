//
// CurrencyConverter
// Created by Viktoriya on 2023
// 
//

import Foundation
import UIKit

protocol ConverterViewProtocol: AnyObject {
    var presenter: ConverterPresenterProtocol? { get set }
    
    // PRESENTER -> VIEW
    
}

protocol ConverterWireFrameProtocol: AnyObject {
    func presentConverterModule(fromView window: AnyObject)
    func showCurrencyListViewController()
    
    // PRESENTER -> WIREFRAME
    
}

protocol ConverterPresenterProtocol: AnyObject {
    var view: ConverterViewProtocol? { get set }
    var interactor: ConverterInteractorInputProtocol? { get set }
    var wireFrame: ConverterWireFrameProtocol? { get set }
    
    //VIEW -> PRESENTER
}

protocol ConverterInteractorOutputProtocol: AnyObject {
    // INTERACTOR -> PRESENTER
    
}

protocol ConverterInteractorInputProtocol: AnyObject {
    var presenter: ConverterInteractorOutputProtocol? { get set }
    // PRESENTER -> INTERACTOR
    
}

protocol ConverterDataManagerInputProtocol: AnyObject {
    // INTERACTOR -> DATAMANAGER
    
}

protocol ConverterAPIDataManagerInputProtocol: AnyObject {
    // INTERACTOR -> APIDATAMANAGER
    
}

protocol ConverterLocalDataManagerInputProtocol: AnyObject {
    // INTERACTOR -> LOCALDATAMANAGER
    
}
