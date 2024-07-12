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
    private var balanceTextField: CustomTextField!
    private var expiryDateTextField: CustomTextField!
    private var cardHolderNameTextField: CustomTextField!
    private var cardTypeTextField: CustomTextField!
    
    private let datePicker = UIDatePicker()

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
        setupDatePicker()
    }
    
    private func setupViews() {
        let closeButton = DismissButton()
        let idLabel = UILabel()
        idLabel.text = "Card ID: \(card.id)"
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        idLabel.isUserInteractionEnabled = true
        
        // MARK: - Tap gesture for copying card ID
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(copyCardId))
        idLabel.addGestureRecognizer(tapGesture)
        
        balanceTextField = CustomTextField(placeholder: "Balance", keyboardType: .decimalPad)
        balanceTextField.text = String(card.balance)
        
        expiryDateTextField = CustomTextField(placeholder: "Expiry Date")
        expiryDateTextField.text = card.expiryDate
        
        cardHolderNameTextField = CustomTextField(placeholder: "Card Holder Name")
        cardHolderNameTextField.text = card.cardHolderName
        
        cardTypeTextField = CustomTextField(placeholder: "Card Type")
        cardTypeTextField.text = card.type
        
        // MARK: - Save button with UIAction
        let saveButton = TabBarsCustomButton(title: "Save", action: UIAction { [weak self] _ in
            self?.saveTapped()
        })
        
        // MARK: - Delete button with UIAction
        let deleteButton = TabBarsCustomButton(title: "Delete", action: UIAction { [weak self] _ in
            self?.deleteTapped()
        }, backgroundColor: .red)
        
        view.addSubview(closeButton)
        view.addSubview(idLabel)
        view.addSubview(balanceTextField)
        view.addSubview(expiryDateTextField)
        view.addSubview(cardHolderNameTextField)
        view.addSubview(cardTypeTextField)
        view.addSubview(saveButton)
        view.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.heightAnchor.constraint(equalToConstant: 40),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            
            idLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 20),
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
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 44),
            
            deleteButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 10),
            deleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            deleteButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100.0, height: 44.0))
        
        // MARK: - Done button with UIAction to set the selected date and dismiss the picker
        let doneAction = UIAction { [weak self] _ in
            self?.expiryDateTextField.text = self?.formatDate(self?.datePicker.date ?? Date())
            self?.expiryDateTextField.resignFirstResponder()
        }
        
        let doneButton = UIBarButtonItem(systemItem: .done, primaryAction: doneAction, menu: nil)
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexSpace, doneButton], animated: true)
        
        expiryDateTextField.inputAccessoryView = toolbar
        expiryDateTextField.inputView = datePicker
    }
    
    @objc private func dateChanged() {
        expiryDateTextField.text = formatDate(datePicker.date)
    }
    
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
    
    @objc private func copyCardId() {
        UIPasteboard.general.string = card.id
        showAlert(title: "Copied", message: "Card ID copied to clipboard.")
    }
    
    // MARK: - Action for Save button
    private func saveTapped() {
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
        
        viewModel.updateCardDetails(cardId: card.id, newBalance: newBalance, newExpiryDate: newExpiryDate, newCardHolderName: newCardHolderName, newType: newType)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Action for Delete button
    private func deleteTapped() {
        let alert = UIAlertController(title: "Delete Card", message: "Are you sure you want to delete this card?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.deleteCard(cardId: self.card.id)
            self.dismiss(animated: true, completion: nil)
        })
        present(alert, animated: true, completion: nil)
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
