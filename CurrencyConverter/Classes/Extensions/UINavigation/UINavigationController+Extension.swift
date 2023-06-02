//
//  UINavigationController.swift
//  CurrencyConverter
//
//  Created by Viktoriya on 02.06.2023.
//

import UIKit

extension UINavigationController {
    func popViewController(animated: Bool, completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popViewController(animated: animated)
        CATransaction.commit()
    }
}
