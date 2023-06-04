//
// CurrencyConverter
// Created by Viktoriya on 2023
// 
//

import Foundation
import UIKit

class ConverterView: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    @IBOutlet private weak var swapButton: UIButton?
    @IBOutlet private weak var refreshButton: CustomButton?
    @IBOutlet private weak var sourceCodeView: CustomView?
    @IBOutlet private weak var targetCodeView: CustomView?
    @IBOutlet private weak var inputValueTextField: UITextField?
    @IBOutlet private weak var outputValueLabel: UILabel?
    
    var presenter: ConverterPresenterProtocol?
    private var defaultCurrencyValue = "0.0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        self.setupViewAppearance()
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController == navigationController.viewControllers.first {
            presenter?.setupCode(sourceCurrency: sourceCodeView?.title ?? "", targetCurrency: targetCodeView?.title ?? "")
        }
    }
    
    private func setupViewAppearance() {
        self.hideKeyboardWhenTappedAround()
        self.navigationItem.setTitle(text: Common.translate("Converter"))
        self.setupCodeViewsAppearance()
        self.setupTextField()
        self.setupOutputValueLabel()
        self.setupRefreshButton()
        self.swapButton?.addTarget(self, action: #selector(swapButtonTapped), for: .touchUpInside)
        self.refreshButton?.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
    }
    
    private func setupCodeViewsAppearance() {
        guard let source = sourceCodeView, let target = targetCodeView else {
            return
        }
        source.type = .source
        target.type = .target
        source.selectionHandle(twin: target)
        target.selectionHandle(twin: source)
        
        source.executeAction = { [weak self] in
            var code = ""
            source.isSelected = true
            
            guard source.isFilled && source.isSelected else {
                code = source.isFilled ? (source.title ?? "") : ""
                self?.presenter?.didSelect(from: .source, with: code)
                return
            }
            
            self?.presenter?.didSelect(from: .source, with: code)
        }
        
        target.executeAction = { [weak self] in
            var code = ""
            target.isSelected = true
            
            guard target.isFilled && target.isSelected else {
                code = target.isFilled ? (target.title ?? "") : ""
                self?.presenter?.didSelect(from: .target, with: code)
                return
            }
            
            self?.presenter?.didSelect(from: .target, with: code)
        }
    }
    
    private func setupTextField() {
        guard let textField = self.inputValueTextField else {
            return
        }
        textField.delegate = self
        textField.backgroundColor = UIColor.clear
        textField.attributedPlaceholder = NSAttributedString(string: self.defaultCurrencyValue,
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.grayTitle, NSAttributedString.Key.font: UIFont.customFont()])
        textField.textColor = UIColor.black
        textField.font = UIFont.customFont()
        textField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .allTouchEvents)
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        self.convertValue(textField.text ?? "", textField: textField)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
           guard let text = textField.text else {
               return
           }
        self.convertValue(text, textField: textField)
       }
    
    private func convertValue(_ text: String, textField: UITextField) {
        guard let sourceView = self.sourceCodeView,
           let targetView = self.targetCodeView,
           let sourceCode = sourceView.title,
           let targetCode = targetView.title,
           sourceView.isFilled,
           targetView.isFilled  else {
            textField.resignFirstResponder()
            self.sourceCodeView?.shake()
            self.targetCodeView?.shake()
            return
        }
        if let text = textField.text,
           !text.isEmpty {
            self.outputValueLabel?.textColor = UIColor.outputLabel
            presenter?.convertValue(text, from: sourceCode, to: targetCode)
        } else {
            self.outputValueLabel?.textColor = UIColor.grayTitle
            self.outputValueLabel?.text = self.defaultCurrencyValue
        }
    }
    
    private func setupOutputValueLabel() {
        guard let label = self.outputValueLabel else {
            return
        }
        label.font = UIFont.customFont()
        label.text = self.defaultCurrencyValue
        label.textColor = UIColor.grayTitle
    }
    
    private func setupRefreshButton() {
        guard let button = self.refreshButton else {
            return
        }
        button.layer.cornerRadius = 8
        let titleLabel = UILabel()
        titleLabel.attributedText = NSAttributedString(string:  Common.translate("Refresh"),
                                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.customFont()])
        
        
        button.setAttributedTitle(titleLabel.attributedText, for: .normal)
    }
    
    @objc func refreshButtonTapped() {
        guard let textField = self.inputValueTextField else {
            return
        }
        
        self.convertValue(textField.text ?? "", textField: textField)
    }
    
    // PRESENTER -> VIEW
    
    @objc func swapButtonTapped() {
        guard let sourceView = self.sourceCodeView,
              let targetView = self.targetCodeView,
              var sourceCode = sourceView.title,
              var targetCode = targetView.title,
              sourceView.isFilled,
              targetView.isFilled else {
            self.sourceCodeView?.shake()
            self.targetCodeView?.shake()
            return
        }
        presenter?.swap(from: &sourceCode, to: &targetCode)
        if let textField = self.inputValueTextField, let text = textField.text {
            self.convertValue(text, textField: textField)
        }
    }
}

extension ConverterView: ConverterViewProtocol {
    func setupCountryCode(_ code: String, for type: CountryCodeType) {
        switch type {
        case .source:
            self.sourceCodeView?.title = code
            self.sourceCodeView?.isFilled = code.isEmpty ? false : true
            self.sourceCodeView?.isSelected = false
        case .target:
            self.targetCodeView?.title = code
            self.targetCodeView?.isFilled = code.isEmpty ? false : true
            self.targetCodeView?.isSelected = false
        }
    }
    
    func updateCountryCode(_ code: String, for type: CountryCodeType) {
        switch type {
        case .source:
            self.sourceCodeView?.title = code
        case .target:
            self.targetCodeView?.title = code
        }
    }
    
    func updateOutput(value: String) {
        self.outputValueLabel?.text = value
    }
    
    func showError(message: String) {
        AlertManager.showErrorAlert(from: self, message: message)
    }
}
