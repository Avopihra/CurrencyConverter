//
// CurrencyConverter
// Created by Viktoriya on 2023
// 
//

import Foundation
import UIKit

class ConverterView: UIViewController {
    
    @IBOutlet private weak var swapButton: UIButton?
    @IBOutlet private weak var sourceCodeView: CustomView?
    @IBOutlet private weak var targetCodeView: CustomView?
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
        self.sourceCodeView?.type = .source
        self.targetCodeView?.type = .target
        
        self.sourceCodeView?.executeAction = {
            self.presenter?.didSelect(from: .source)
        }
        self.targetCodeView?.executeAction = {
            self.presenter?.didSelect(from: .target)
        }
    }
    
    
    
    // PRESENTER -> VIEW
    
    func didSelectButtonTapped(from type: CountryCodeType) {
        presenter?.didSelect(from: type)
    }
    
     func swapButtonTapped() {
         
         guard var sourceCode = self.sourceCodeView?.title, var targetCode = targetCodeView?.title else {
            return
        }
        presenter?.swapContryCodes(from: &sourceCode, to: &targetCode)
    }
    
    func refreshButtonTapped() {
        presenter?.refresh()
    }
}

extension ConverterView: ConverterViewProtocol {
    func setupCountryCode(_ code: String, for type: CountryCodeType) {
        switch type {
        case .source:
            self.sourceCodeView?.title = code
            self.sourceCodeView?.isAppointed = true
        case .target:
            self.targetCodeView?.title = code
            self.targetCodeView?.isAppointed = true
        }
    }
    
    func updateOutput(value: String) {
        self.outputValueLabel?.text = value
    }
    
    func showError(message: String) {
        AlertManager.showErrorAlert(from: self, message: message)
    }
}
