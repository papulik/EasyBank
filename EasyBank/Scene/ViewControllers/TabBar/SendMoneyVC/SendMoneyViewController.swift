//
//  SendMoneyViewController.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 05.07.24.
//

import UIKit

class SendMoneyViewController: UIViewController {
    var viewModel: HomeViewModel
    weak var coordinator: AppCoordinator?
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var fromCardIdTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "From Card ID"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var toCardIdTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "To Card ID"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Amount"
        textField.keyboardType = .decimalPad
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send Money", for: .normal)
        button.addTarget(self, action: #selector(sendMoneyTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(fromCardIdTextField)
        view.addSubview(toCardIdTextField)
        view.addSubview(amountTextField)
        view.addSubview(sendButton)
        
        NSLayoutConstraint.activate([
            fromCardIdTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            fromCardIdTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            fromCardIdTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            toCardIdTextField.topAnchor.constraint(equalTo: fromCardIdTextField.bottomAnchor, constant: 20),
            toCardIdTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            toCardIdTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            amountTextField.topAnchor.constraint(equalTo: toCardIdTextField.bottomAnchor, constant: 20),
            amountTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            amountTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            sendButton.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 20),
            sendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func sendMoneyTapped() {
        guard let fromCardId = fromCardIdTextField.text,
              let toCardId = toCardIdTextField.text,
              let amountText = amountTextField.text,
              let amount = Double(amountText) else {
            print("Invalid input")
            return
        }
        
        guard let fromCard = viewModel.currentUser?.cards.first(where: { $0.id == fromCardId }),
              let toCard = viewModel.users.flatMap({ $0.cards }).first(where: { $0.id == toCardId }) else {
            print("Invalid card IDs")
            return
        }
        
        viewModel.sendMoney(fromCard: fromCard, toCard: toCard, amount: amount)
    }
}

