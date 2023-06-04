//
//  CurrencyListCell.swift
//  CurrencyConverter
//
//  Created by Viktoriya on 01.06.2023.
//

import UIKit

class CurrencyListCell: UITableViewCell {
    @IBOutlet private weak var nameLabel: UILabel?
    
    var name: String? {
        didSet{
            self.nameLabel?.text = name
            self.setupCellAppearance()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupCellAppearance()
    }
    
    private func setupCellAppearance() {
        self.backgroundColor = .white
        self.nameLabel?.textColor = .black
        self.nameLabel?.font = UIFont.customFont()
        self.nameLabel?.text = name ?? ""
    }
}
