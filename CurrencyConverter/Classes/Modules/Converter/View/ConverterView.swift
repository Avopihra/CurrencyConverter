//
// CurrencyConverter
// Created by Viktoriya on 2023
// 
//

import Foundation
import UIKit

class ConverterView: UIViewController {
    
    @IBOutlet private weak var swapButton: UIButton?
    @IBOutlet private weak var baseCodeView: CustomView?
    @IBOutlet private weak var quoteCodeView: CustomView?
    @IBOutlet private weak var inputValueTextField: UITextField?
    @IBOutlet private weak var outputValueLabel: UILabel?
    
    var presenter: ConverterPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViewAppearance()
    }
    
    private func setupViewAppearance() {
        self.navigationItem.setTitle(text: Common.translate("Converter"))
        self.setupCodeViewsAppearance()
    }
    
    private func setupCodeViewsAppearance() {
        self.baseCodeView?.type = .base
        self.quoteCodeView?.type = .quote
        
        self.baseCodeView?.executeAction = {
            self.presenter?.didSelect(from: .base)
        }
        self.quoteCodeView?.executeAction = {
            self.presenter?.didSelect(from: .quote)
        }
    }
    
    
    
    // PRESENTER -> VIEW
    
    func didSelectButtonTapped(from type: CountryCodeType) {
        presenter?.didSelect(from: type)
    }
    
     func swapButtonTapped() {
         
         guard var baseCode = self.baseCodeView?.title, var quoteCode = quoteCodeView?.title else {
            return
        }
        presenter?.swapContryCodes(from: &baseCode, to: &quoteCode)
    }
    
    func refreshButtonTapped() {
        presenter?.refresh()
    }
}

extension ConverterView: ConverterViewProtocol {
    func setupCountryCode(_ code: String, for type: CountryCodeType) {
        switch type {
        case .base:
            self.baseCodeView?.title = code
        case .quote:
            self.quoteCodeView?.title = code
        }
    }
    
    func updateOutput(value: String) {
        self.outputValueLabel?.text = value
    }
    
    func showError(message: String) {
        AlertManager.showErrorAlert(from: self, message: message)
    }
}
