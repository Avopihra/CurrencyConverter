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
    
    static func showLoader(from controller: UIViewController, isShow: Bool = true) {
        let alert = UIAlertController(title: nil, message: Common.translate("Alert.wait"), preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating()
        if isShow {
            alert.view.addSubview(loadingIndicator)
            controller.present(alert, animated: true, completion: nil)
        } else {
            if let overlay = controller.presentedViewController, overlay is UIAlertController {
                overlay.dismiss(animated: false, completion: nil)
            }
        }
    }
}
