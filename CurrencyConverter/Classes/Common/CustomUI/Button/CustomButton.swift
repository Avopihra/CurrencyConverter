//
//  CustomButton.swift
//  CurrencyConverter
//
//  Created by Viktoriya on 03.06.2023.
//

import UIKit

//MARK: - Custom Button Class

final class CustomButton: TouchableButton {

    var isAvailable: Bool = true {
        didSet {
            self.updateAvailability(isAvailable)
        }
    }

    init() {
        super.init(frame: .zero)
        customInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        customInit()
    }
}

 private extension CustomButton {
     
    func customInit() {
        self.setupText()
        self.setupColor()
        self.updateButtonStyle()
    }

    func setupText() {
        self.setupTitleTextColor()
        self.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.minimumScaleFactor = 0.5
    }

    func setupTitleTextColor() {
        self.setTitleColor(UIColor.white, for: .normal)
    }

    func setupColor() {
        self.backgroundColor = UIColor.enabledButton
    }
    
    func updateAvailability(_ isAvailable: Bool) {
        self.isUserInteractionEnabled = isAvailable
        AnimationManager.animate {
            self.backgroundColor = isAvailable ? UIColor.enabledButton : UIColor.disabledButton
        }
        self.layoutSubviews()
        self.layoutIfNeeded()
    }
    
    func updateButtonStyle() {
        self.setupColor()
        self.setupTitleTextColor()
    }
}
