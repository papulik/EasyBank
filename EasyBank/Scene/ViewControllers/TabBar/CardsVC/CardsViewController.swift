//
//  CardsViewController.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 05.07.24.
//

import UIKit

class CardsViewController: UIViewController {
    private var viewModel: CardsViewModel
    weak var coordinator: AppCoordinator?
    
    init(viewModel: CardsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Card", for: .normal)
        button.addTarget(self, action: #selector(addCardTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cardCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Cards"
        
        setupViews()
        viewModel.delegate = self
        viewModel.fetchCards()
    }
    
    private func setupViews() {
        view.addSubview(addButton)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func addCardTapped() {
        let alert = UIAlertController(title: "Add Card", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Initial Balance"
            textField.keyboardType = .decimalPad
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            if let balanceText = alert.textFields?.first?.text, let balance = Double(balanceText) {
                self?.viewModel.addCard(balance: balance)
            }
        })
        present(alert, animated: true, completion: nil)
    }
}

extension CardsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath)
        let card = viewModel.cards[indexPath.row]
        cell.textLabel?.text = "Card \(card.id): \(card.balance) ₾"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let card = viewModel.cards[indexPath.row]
        let cardDetailVC = CardDetailViewController(card: card)
        navigationController?.pushViewController(cardDetailVC, animated: true)
    }
}

extension CardsViewController: CardsViewModelDelegate {
    func didUpdateCards() {
        tableView.reloadData()
    }
    
    func didEncounterError(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

import UIKit

class CardDetailViewController: UIViewController {
    private var card: Card
    private var balanceTextField: UITextField!
    
    init(card: Card) {
        self.card = card
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Card Details"
        
        setupViews()
    }
    
    private func setupViews() {
        let idLabel = UILabel()
        idLabel.text = "Card ID: \(card.id)"
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        
        balanceTextField = UITextField()
        balanceTextField.text = String(card.balance)
        balanceTextField.keyboardType = .decimalPad
        balanceTextField.borderStyle = .roundedRect
        balanceTextField.translatesAutoresizingMaskIntoConstraints = false
        
        let saveButton = UIButton(type: .system)
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(idLabel)
        view.addSubview(balanceTextField)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            idLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            idLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            idLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            balanceTextField.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 20),
            balanceTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            balanceTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            saveButton.topAnchor.constraint(equalTo: balanceTextField.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func saveTapped() {
        guard let balanceText = balanceTextField.text, let _ = Double(balanceText) else {
            showAlert(title: "Invalid Input", message: "Please enter a valid balance.")
            return
        }
        
        
    }
    
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true, completion: nil)
    }
}
