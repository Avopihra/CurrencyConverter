//
//  AlertManager.swift
//  CurrencyConverter
//
//  Created by Viktoriya on 30.05.2023.
//

import UIKit

final class AlertManager {
    
    static func showErrorAlert(from controller: UIViewController, message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: Common.translate("Alert.ok"), style: .cancel) { _ in
        })
        controller.present(alert, animated: true)
    }
}
