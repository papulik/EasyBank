//
//  CurrencyViewController.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 12.07.24.
//

import UIKit

class CurrencyViewController: UIViewController {
    private var viewModel: CurrencyViewModel
    weak var coordinator: AppCoordinator?
    
    private var refreshControl = UIRefreshControl()
    
    init(viewModel: CurrencyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search Currency"
        textField.borderStyle = .roundedRect
        let iconView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        iconView.tintColor = .gray
        iconView.contentMode = .center
        let iconContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 30))
        iconView.frame = CGRect(x: 10, y: 0, width: 25, height: 30)
        iconContainerView.addSubview(iconView)
        textField.leftViewMode = .always
        textField.leftView = iconContainerView
        textField.clearButtonMode = .whileEditing
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CurrencyTableViewCell.self, forCellReuseIdentifier: CurrencyTableViewCell.reuseIdentifier)
        tableView.rowHeight = 60
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.refreshControl = refreshControl
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Currencies"
        
        setupViews()
        setupRefreshControl()
        viewModel.delegate = self
        viewModel.fetchCurrencies()
    }
    
    private func setupViews() {
        view.addSubview(searchTextField)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            searchTextField.heightAnchor.constraint(equalToConstant: 50),
            
            tableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshCurrencyData), for: .valueChanged)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        viewModel.filterCurrencies(with: textField.text ?? "")
    }
    
    @objc private func refreshCurrencyData() {
        viewModel.fetchCurrencies()
    }
}

// MARK: - TableView Extension
extension CurrencyViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionKey = viewModel.sectionTitles[section]
        return viewModel.currenciesGrouped[sectionKey]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyTableViewCell.reuseIdentifier, for: indexPath) as! CurrencyTableViewCell
        let sectionKey = viewModel.sectionTitles[indexPath.section]
        if let currency = viewModel.currenciesGrouped[sectionKey]?[indexPath.row] {
            cell.configure(with: currency)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sectionTitles[section]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return viewModel.sectionTitles
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return viewModel.sectionTitles.firstIndex(of: title) ?? index
    }
}

// MARK: - ViewModel Extension
extension CurrencyViewController: CurrencyViewModelDelegate {
    func didUpdateCurrencies() {
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
    
    func didEncounterError(_ error: String) {
        refreshControl.endRefreshing()
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
