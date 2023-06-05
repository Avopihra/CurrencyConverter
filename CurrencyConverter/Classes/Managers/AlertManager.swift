//
//  AlertManager.swift
//  CurrencyConverter
//
//  Created by Viktoriya on 30.05.2023.
//

import UIKit

final class AlertManager {
    
    static func showErrorAlert(for error: Error, from controller: UIViewController) {
        var message: String = ""
        switch error {
        case ErrorHandling.invalidURL:
            message = Common.translate("Error.InvalidURL")
        case ErrorHandling.invalidData:
            message = Common.translate("Error.InvalidData")
        case ErrorHandling.invalidResponse:
            message = Common.translate("Error.InvalidResponse")
        case ErrorHandling.invalidConversionRate:
            message = Common.translate("Error.InvalidConversionRate")
        case ErrorHandling.internetError:
            message = Common.translate("Error.InternetConnectionError")
        default:
            message = Common.translate("Error.SomethingWentWrong")
        }
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: Common.translate("Alert.ok"), style: .cancel) { _ in
        })
        controller.present(alert, animated: true)
    }
}
