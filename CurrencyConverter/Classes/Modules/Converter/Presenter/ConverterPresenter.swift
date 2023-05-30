//
// CurrencyConverter
// Created by Viktoriya on 2023
// 
//

import Foundation
import UIKit

class ConverterPresenter: ConverterPresenterProtocol, ConverterInteractorOutputProtocol {
    weak var view: ConverterViewProtocol?
    var interactor: ConverterInteractorInputProtocol?
    var wireFrame: ConverterWireFrameProtocol?
    
    init() {}
    
    // VIEW -> PRESENTER
     
    // INTERACTOR -> PRESENTER
}
