//
//  CardDetailViewController.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 06.07.24.
//

import UIKit

class CardDetailViewController: UIViewController {
    private var card: Card
    private var viewModel: CardsViewModel
    private var balanceTextField: UITextField!
    private var expiryDateTextField: UITextField!
    private var cardHolderNameTextField: UITextField!
    private var cardTypeTextField: UITextField!
    
    init(card: Card, viewModel: CardsViewModel) {
        self.card = card
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = self
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
        
        expiryDateTextField = UITextField()
        expiryDateTextField.text = card.expiryDate
        expiryDateTextField.borderStyle = .roundedRect
        expiryDateTextField.translatesAutoresizingMaskIntoConstraints = false
        
        cardHolderNameTextField = UITextField()
        cardHolderNameTextField.text = card.cardHolderName
        cardHolderNameTextField.borderStyle = .roundedRect
        cardHolderNameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        cardTypeTextField = UITextField()
        cardTypeTextField.text = card.type
        cardTypeTextField.borderStyle = .roundedRect
        cardTypeTextField.translatesAutoresizingMaskIntoConstraints = false
        
        let saveButton = UIButton(type: .system)
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(idLabel)
        view.addSubview(balanceTextField)
        view.addSubview(expiryDateTextField)
        view.addSubview(cardHolderNameTextField)
        view.addSubview(cardTypeTextField)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            idLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            idLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            idLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            balanceTextField.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 20),
            balanceTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            balanceTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            expiryDateTextField.topAnchor.constraint(equalTo: balanceTextField.bottomAnchor, constant: 20),
            expiryDateTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            expiryDateTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            cardHolderNameTextField.topAnchor.constraint(equalTo: expiryDateTextField.bottomAnchor, constant: 20),
            cardHolderNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cardHolderNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            cardTypeTextField.topAnchor.constraint(equalTo: cardHolderNameTextField.bottomAnchor, constant: 20),
            cardTypeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cardTypeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            saveButton.topAnchor.constraint(equalTo: cardTypeTextField.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func saveTapped() {
        guard let balanceText = balanceTextField.text, let newBalance = Double(balanceText),
              let newExpiryDate = expiryDateTextField.text,
              let newCardHolderName = cardHolderNameTextField.text,
              let newType = cardTypeTextField.text else {
            showAlert(title: "Invalid Input", message: "Please enter valid details.")
            return
        }
        
        card.balance = newBalance
        card.expiryDate = newExpiryDate
        card.cardHolderName = newCardHolderName
        card.type = newType
        
        viewModel.updateCardBalance(cardId: card.id, newBalance: newBalance)
        dismiss(animated: true, completion: nil)
    }
    
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension CardDetailViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
}
