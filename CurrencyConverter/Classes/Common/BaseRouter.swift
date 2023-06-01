//
//  BaseRouter.swift
//  CurrencyConverter
//
//  Created by Viktoriya on 30.05.2023.
//

import Foundation
import UIKit

class BaseRouter : NSObject {
    func showRootViewController(_ viewController: UIViewController, window: UIWindow) {
        let navigationController = UINavigationController()
        navigationController.viewControllers = [viewController]
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
