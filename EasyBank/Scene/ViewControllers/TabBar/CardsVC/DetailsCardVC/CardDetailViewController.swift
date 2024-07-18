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
    private var closeButton: UIButton!
    private var idIcon: UIImageView!
    private var idLabel: UILabel!
    private var idStackView: UIStackView!
    private var saveButton: UIButton!
    private var deleteButton: UIButton!
    
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
        setupViews()
    }
    
    private func setupViews() {
        setupBackground()
        setupCloseButton()
        setupIdStackView()
        setupTextFields()
        setupButtons()
        setupConstraints()
        setupDatePicker()
    }
    
    private func setupBackground() {
        view.backgroundColor = UIColor.systemBackground
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 10
    }
    
    private func setupCloseButton() {
        closeButton = DismissButton()
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        view.addSubview(closeButton)
    }
    
    private func setupIdStackView() {
        idIcon = UIImageView(image: UIImage(systemName: "doc.on.doc"))
        idIcon.tintColor = .secondaryLabel
        idIcon.translatesAutoresizingMaskIntoConstraints = false
        idIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        idIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        idLabel = UILabel()
        idLabel.text = card.id
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        idLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        idLabel.textColor = .secondaryLabel
        idLabel.isUserInteractionEnabled = true
        
        idStackView = UIStackView(arrangedSubviews: [idIcon, idLabel])
        idStackView.axis = .horizontal
        idStackView.spacing = 8
        idStackView.alignment = .center
        idStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(copyCardId))
        idStackView.addGestureRecognizer(tapGesture)
        
        view.addSubview(idStackView)
    }
    
    private func setupTextFields() {
        balanceTextField = CustomTextField(placeholder: "Balance", keyboardType: .decimalPad)
        balanceTextField.borderStyle = .roundedRect
        balanceTextField.textColor = .secondaryLabel
        balanceTextField.text = String(card.balance)
        view.addSubview(balanceTextField)
        
        expiryDateTextField = CustomTextField(placeholder: "Expiry Date")
        expiryDateTextField.borderStyle = .roundedRect
        expiryDateTextField.textColor = .secondaryLabel
        expiryDateTextField.text = card.expiryDate
        view.addSubview(expiryDateTextField)
        
        cardHolderNameTextField = CustomTextField(placeholder: "Card Holder Name")
        cardHolderNameTextField.borderStyle = .roundedRect
        cardHolderNameTextField.textColor = .secondaryLabel
        cardHolderNameTextField.text = card.cardHolderName
        view.addSubview(cardHolderNameTextField)
        
        cardTypeTextField = CustomTextField(placeholder: "Card Type")
        cardTypeTextField.borderStyle = .roundedRect
        cardTypeTextField.textColor = .secondaryLabel
        cardTypeTextField.text = card.type
        view.addSubview(cardTypeTextField)
    }
    
    private func setupButtons() {
        saveButton = createButton(title: "Save", imageName: "pencil", action: UIAction(handler: { [weak self] _ in
            self?.saveTapped()
        }))
        view.addSubview(saveButton)
        
        deleteButton = createButton(title: "Delete", imageName: "trash", backgroundColor: .systemRed, action: UIAction(handler: { [weak self] _ in
            self?.deleteTapped()
        }))
        view.addSubview(deleteButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.heightAnchor.constraint(equalToConstant: 40),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            
            idStackView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 20),
            idStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            idStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            balanceTextField.topAnchor.constraint(equalTo: idStackView.bottomAnchor, constant: 20),
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
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        toolbar.barTintColor = .systemBackground
        toolbar.tintColor = .systemBlue
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexSpace, doneButton], animated: true)
        
        expiryDateTextField.inputAccessoryView = toolbar
        expiryDateTextField.inputView = datePicker
    }
    
    private func createButton(title: String, imageName: String, backgroundColor: UIColor = .systemBlue, action: UIAction) -> UIButton {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.image = UIImage(systemName: imageName)
        config.imagePadding = 8
        config.imagePlacement = .leading
        config.baseBackgroundColor = backgroundColor
        config.cornerStyle = .large
        
        let button = UIButton(configuration: config, primaryAction: action)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        return button
    }
    
    //MARK: - Actions
    @objc private func doneTapped() {
        expiryDateTextField.text = formatDate(datePicker.date)
        expiryDateTextField.resignFirstResponder()
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
    
    @objc private func closeTapped() {
        dismiss(animated: true, completion: nil)
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
        
        viewModel.updateCardDetails(cardId: card.id, newBalance: newBalance, newExpiryDate: newExpiryDate, newCardHolderName: newCardHolderName, newType: newType)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func deleteTapped() {
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
