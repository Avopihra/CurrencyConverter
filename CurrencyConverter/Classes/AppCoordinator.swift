//
//  AppDependencies.swift
//  CurrencyConverter
//
//  Created by Viktoriya on 30.05.2023.
//

import UIKit
import CoreData

class AppCoordinator {
        
    var converterRouter = ConverterRouter()
    private let window: UIWindow
    private var persistentContainer: NSPersistentContainer?
    
    init(window: UIWindow, persistentContainer: NSPersistentContainer?) {
        self.window = window
        self.persistentContainer = persistentContainer
        self.configureDependencies()
    }
    
    //MARK: - Build Modules

    func installRootViewController() {
        converterRouter.presentConverterModule(fromView: window)
    }
    
    private func configureDependencies() {
        let baseRouter = BaseRouter()
        let dataManager = DataManager(persistentContainer: persistentContainer ?? NSPersistentContainer())
        let currencyListRouter = CurrencyListRouter()
        let converterDataManager = ConverterAPIDataManager(dataManager)
        let currencyListDataManager = CurrencyListLocalDataManager(dataManager)
        
        // Converter
        let converterPresenter = ConverterPresenter()
        let converterIntractor = ConverterInteractor(dataManager: converterDataManager)
        
        converterIntractor.presenter = converterPresenter
        converterPresenter.interactor = converterIntractor
        converterPresenter.router = converterRouter
        
        converterRouter.baseRouter = baseRouter
        converterRouter.currencyListRouter = currencyListRouter
        converterRouter.presenter = converterPresenter
 
        // CurrencyList
        let currencyListPresenter = CurrencyListPresenter()
        let currencyListInteractor = CurrencyListInteractor(dataManager: currencyListDataManager)

        currencyListInteractor.presenter = currencyListPresenter
        currencyListPresenter.interactor = currencyListInteractor
        currencyListPresenter.router = currencyListRouter
 
        currencyListRouter.baseRouter = baseRouter //
        currencyListRouter.presenter = currencyListPresenter
        currencyListRouter.converterPresenter = converterPresenter
    }
}
