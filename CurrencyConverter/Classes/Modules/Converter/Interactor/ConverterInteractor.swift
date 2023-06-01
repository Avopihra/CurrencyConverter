//
// CurrencyConverter
// Created by Viktoriya on 2023
// 
//

import Foundation

class ConverterInteractor: ConverterInteractorInputProtocol {
    weak var presenter: ConverterInteractorOutputProtocol?
    
    private let localDataManager: ConverterAPIDataManagerInputProtocol
    
    init(dataManager: ConverterAPIDataManagerInputProtocol) {
        self.localDataManager = dataManager
    }
    
    // PRESENTER -> INTERACTOR
}
