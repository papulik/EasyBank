//
//  AddCardViewController.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 19.07.24.
//

import UIKit

class AddCardViewController: UIViewController {
    var onAddCard: ((Double, String, String, String) -> Void)?
    
    private lazy var balanceTextField: CustomTextField = {
        let textField = CustomTextField(placeholder: "Initial Balance", keyboardType: .decimalPad)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray4.cgColor
        textField.layer.cornerRadius = 10
        textField.setPadding(left: 10, right: 10)
        return textField
    }()
    
    private lazy var expiryDatePicker: CustomDatePicker = {
        let datePicker = CustomDatePicker(placeholder: "Expiry Date")
        datePicker.textField.layer.borderWidth = 1
        datePicker.textField.layer.borderColor = UIColor.systemGray4.cgColor
        datePicker.textField.layer.cornerRadius = 10
        datePicker.textField.setPadding(left: 10, right: 10)
        return datePicker
    }()
    
    private lazy var cardHolderNameTextField: CustomTextField = {
        let textField = CustomTextField(placeholder: "Card Holder Name")
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray4.cgColor
        textField.layer.cornerRadius = 10
        textField.setPadding(left: 10, right: 10)
        return textField
    }()
    
    private lazy var cardTypeTextField: CustomTextField = {
        let textField = CustomTextField(placeholder: "Card Type")
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray4.cgColor
        textField.layer.cornerRadius = 10
        textField.setPadding(left: 10, right: 10)
        return textField
    }()
    
    private lazy var addButton: TabBarsCustomButton = {
        let button = TabBarsCustomButton(title: "Add Card", action: UIAction { [weak self] _ in
            self?.addCardTapped()
        })
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor.systemBlue
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private lazy var closeButton: UIButton = {
        let button = DismissButton()
        button.addAction(UIAction { [weak self] _ in
            self?.closeTapped()
        }, for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Add Card"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupBackground()
        setupUI()
        setupConstraints()
    }
    
    private func setupBackground() {
        view.backgroundColor = UIColor.systemBackground
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 10
    }
    
    private func setupUI() {
        [closeButton, titleLabel, balanceTextField, expiryDatePicker.textField, cardHolderNameTextField, cardTypeTextField, addButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.heightAnchor.constraint(equalToConstant: 40),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            balanceTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            balanceTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            balanceTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            balanceTextField.heightAnchor.constraint(equalToConstant: 50),
            
            expiryDatePicker.textField.topAnchor.constraint(equalTo: balanceTextField.bottomAnchor, constant: 20),
            expiryDatePicker.textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            expiryDatePicker.textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            expiryDatePicker.textField.heightAnchor.constraint(equalToConstant: 50),
            
            cardHolderNameTextField.topAnchor.constraint(equalTo: expiryDatePicker.textField.bottomAnchor, constant: 20),
            cardHolderNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cardHolderNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cardHolderNameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            cardTypeTextField.topAnchor.constraint(equalTo: cardHolderNameTextField.bottomAnchor, constant: 20),
            cardTypeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cardTypeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cardTypeTextField.heightAnchor.constraint(equalToConstant: 50),
            
            addButton.topAnchor.constraint(equalTo: cardTypeTextField.bottomAnchor, constant: 20),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func addCardTapped() {
        guard let balanceText = balanceTextField.text, let balance = Double(balanceText),
              let expiryDate = expiryDatePicker.textField.text,
              let cardHolderName = cardHolderNameTextField.text,
              let cardType = cardTypeTextField.text else {
            showAlert(title: "Invalid Input", message: "Please enter valid details.")
            return
        }
        
        onAddCard?(balance, expiryDate, cardHolderName, cardType)
        dismiss(animated: true, completion: nil)
    }
    
    private func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension AddCardViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
}
