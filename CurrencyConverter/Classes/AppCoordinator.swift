//
//  AppDependencies.swift
//  CurrencyConverter
//
//  Created by Viktoriya on 30.05.2023.
//

import UIKit

class AppCoordinator {
        
    var converterRouter = ConverterRouter()
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        self.configureDependencies()
    }
    
    //MARK: - Build Modules

    func installRootViewController() {
        converterRouter.presentConverterModule(fromView: window)
    }
    
    func configureDependencies() {
        let baseRouter = BaseRouter()
        let currencyListRouter = CurrencyListRouter()
        
        // Converter
        let converterPresenter = ConverterPresenter()
        let converterAPIDataManager = ConverterAPIDataManager()
        let converterIntractor = ConverterInteractor()
        
        converterIntractor.presenter = converterPresenter
        
        converterPresenter.interactor = converterIntractor
        converterPresenter.router = converterRouter
        
        converterRouter.baseRouter = baseRouter
        converterRouter.currencyListRouter = currencyListRouter
        converterRouter.presenter = converterPresenter
 
        // CurrencyList
        let currencyListPresenter = CurrencyListPresenter()
        let currencyListAPIDataManager = CurrencyListAPIDataManager()
        let currencyListInteractor = CurrencyListInteractor()

        currencyListInteractor.presenter = currencyListPresenter
        
        currencyListPresenter.interactor = currencyListInteractor
        currencyListPresenter.router = currencyListRouter
 
        currencyListRouter.currencyListPresenter = currencyListPresenter
        currencyListRouter.converterPresenter = converterPresenter
    }
}
