//
// CurrencyConverter
// Created by Viktoriya on 2023
// 
//

import Foundation
import UIKit

class CurrencyListView: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: CurrencyListPresenterProtocol?
    private var itemList: [Currency] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewAppearance()
     }
    
    //MARK: - Private Methods

    private func setupViewAppearance() {
        self.navigationItem.setTitle(text: Common.translate("Currency List"))
        self.setupTableView()
    }
    
    private func setupTableView() {
        guard let tableView = self.tableView else {
            return
        }
        tableView.register(UINib(nibName: "CurrencyListCell", bundle: nil),
                           forCellReuseIdentifier: "CurrencyListCell")
        tableView.backgroundColor = UIColor.white
        tableView.dataSource = self
        tableView.delegate = self
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate

extension CurrencyListView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.rowsCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CurrencyListCell.self), for: indexPath) as? CurrencyListCell, itemList.count > 0 else {
            return UITableViewCell()
        }
        cell.name = itemList[indexPath.row].name
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}

extension CurrencyListView: CurrencyListViewProtocol {
    

}
