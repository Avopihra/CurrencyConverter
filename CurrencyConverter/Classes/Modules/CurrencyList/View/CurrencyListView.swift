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
    var sourceCurrency: String?
    var targetCurrency: String?
    
    private var currencyList: [String]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter?.loadCurrencyList(sourceCurrency: self.sourceCurrency, targetCurrency: self.targetCurrency)
        self.setupViewAppearance()
    }
    
    //MARK: - Private Methods
    
    private func setupViewAppearance() {
        self.navigationItem.setTitle(text: Common.translate("List.CurrencyList"))
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
        return presenter?.rowCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CurrencyListCell.self), for: indexPath) as? CurrencyListCell else {
            return UITableViewCell()
        }
        cell.name = presenter?.currencyList?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HapticManager.notify(.success)
        self.navigationController?.popViewController(animated: true, completion: {
            self.presenter?.didSelectCell(at: indexPath.row)
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}

extension CurrencyListView: CurrencyListViewProtocol {
    
    func displayCurrencyList(_ currencyList: [String]) {
        self.currencyList = currencyList
        self.tableView?.reloadData()
    }
    
    func displayError(_ message: String) {
        HapticManager.notify(.error)
        AlertManager.showErrorAlert(from: self, message: message)
    }
}
