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
    }
    
    //MARK: - Build Modules

    func installRootViewController() {
        converterRouter.presentConverterModule(fromView: window)
    }
}
