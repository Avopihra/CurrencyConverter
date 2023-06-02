//
//  CustomView.swift
//  CurrencyConverter
//
//  Created by Viktoriya on 31.05.2023.
//

import UIKit

enum CountryCodeType {
    case source
    case target
}

class CustomView: UIView {
    
    @IBOutlet private weak var titleLabel: UILabel?
    
    var type: CountryCodeType?
    var executeAction: (() -> Void)?
    
    var isAppointed: Bool = false {
        didSet {
            self.updateTitleLabel()
        }
    }
    
    var title: String? = ""{
        didSet {
            self.updateTitleLabel()
        }
    }
    
    private let nibName = "CustomView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func addAction(for type: CountryCodeType, completion: () -> Void) {
        self.type = type
        completion()
    }
    
    //MARK: - Private Methods
    
    private func commonInit() {
        guard let view = loadViewFromNib() else { return }
        
        view.frame = self.bounds
        self.addSubview(view)
        self.setupView()
    }
        
    private func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    private func setupView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        self.addGestureRecognizer(tapGesture)
        self.setupPreference()
    }
    
    @objc private func viewTapped() {
        self.executeAction?()
        self.isAppointed = !self.isAppointed
    }
    
    private func setupPreference() {
        
        self.updateTitleLabel()
        self.layer.cornerRadius = 8.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.grayBorder.cgColor
    }
    
    private func updateTitleLabel() {
        self.titleLabel?.textColor = isAppointed ? UIColor.black : UIColor.grayTitle
        self.titleLabel?.text = isAppointed ? self.title : Common.translate("Currency")
    }
}
