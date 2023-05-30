//
// CurrencyConverter
// Created by Viktoriya on 2023
// 
//

import Foundation
import UIKit

class CurrencyListView: UIViewController {
    
    var presenter: CurrencyListPresenterProtocol?    

    override func viewDidLoad() {
        super.viewDidLoad()
        
     }
}

extension CurrencyListView: CurrencyListViewProtocol {
    

}
