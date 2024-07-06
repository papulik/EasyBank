//
//  SendMoneyVC.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 05.07.24.
//

import UIKit

class SendMoneyViewController: UIViewController {
    private var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let fromCardIdTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "From Card ID"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let toCardIdTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "To Card ID"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Amount"
        textField.keyboardType = .decimalPad
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send Money", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupActions()
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
    
    private func setupActions() {
        sendButton.addAction(UIAction { [weak self] _ in
            self?.sendMoneyTapped()
        }, for: .touchUpInside)
    }
    
    private func sendMoneyTapped() {
        guard let fromCardId = fromCardIdTextField.text,
              let toCardId = toCardIdTextField.text,
              let amountText = amountTextField.text,
              let amount = Double(amountText) else {
            print("Invalid input")
            showAlert(title: "Invalid Input", message: "Please check the input values.")
            return
        }
        
        print("Sending money from \(fromCardId) to \(toCardId) amount \(amount)")
        
        viewModel.sendMoney(fromCardId: fromCardId, toCardId: toCardId, amount: amount) { [weak self] result in
            switch result {
            case .success:
                self?.showAlert(title: "Success", message: "Money sent successfully.") {
                    self?.dismiss(animated: true, completion: nil)
                }
            case .failure(let error):
                self?.showAlert(title: "Error", message: "Error sending money: \(error.localizedDescription)")
            }
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

extension SendMoneyViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
}
