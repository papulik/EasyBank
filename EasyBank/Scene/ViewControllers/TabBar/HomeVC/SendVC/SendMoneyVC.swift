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
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let fromCardIdTextField: CustomTextField = {
        let textField = CustomTextField(placeholder: "")
        let chevron = UIImage(systemName: "chevron.down")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        let chevronAttachment = NSTextAttachment(image: chevron!)
        let attributedString = NSMutableAttributedString(string: "From Card ID  ")
        attributedString.append(NSAttributedString(attachment: chevronAttachment))
        textField.attributedPlaceholder = attributedString
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray4.cgColor
        textField.layer.cornerRadius = 10
        textField.setPadding(left: 10, right: 10)
        return textField
    }()
    
    private let toCardIdTextField: CustomTextField = {
        let textField = CustomTextField(placeholder: "To Card ID")
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray4.cgColor
        textField.layer.cornerRadius = 10
        textField.setPadding(left: 10, right: 10)
        return textField
    }()
    
    private let amountTextField: CustomTextField = {
        let textField = CustomTextField(placeholder: "Amount", keyboardType: .decimalPad)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray4.cgColor
        textField.layer.cornerRadius = 10
        textField.setPadding(left: 10, right: 10)
        return textField
    }()
    
    private lazy var sendButton: TabBarsCustomButton = {
        let button = TabBarsCustomButton(title: "Send Money", action: UIAction { [weak self] _ in
            self?.sendMoneyTapped()
        })
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor.systemGreen
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        
        let lariImageView = UIImageView(image: UIImage(systemName: "larisign"))
        lariImageView.tintColor = .white
        lariImageView.translatesAutoresizingMaskIntoConstraints = false
        
        button.addSubview(lariImageView)
        
        NSLayoutConstraint.activate([
            lariImageView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            lariImageView.trailingAnchor.constraint(equalTo: button.titleLabel!.trailingAnchor, constant: 30)
        ])
        
        return button
    }()
    
    private let cardIdPickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupBackground()
        setupViews()
        setupPickerView()
    }
    
    private func setupBackground() {
        view.backgroundColor = UIColor.systemBackground
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 10
    }
    
    private func setupViews() {
        let closeButton = DismissButton()
        closeButton.tintColor = .black
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        
        let titleLabel = UILabel()
        titleLabel.text = "Send Money"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(closeButton)
        view.addSubview(titleLabel)
        view.addSubview(fromCardIdTextField)
        view.addSubview(toCardIdTextField)
        view.addSubview(amountTextField)
        view.addSubview(sendButton)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.heightAnchor.constraint(equalToConstant: 40),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            fromCardIdTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            fromCardIdTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            fromCardIdTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            fromCardIdTextField.heightAnchor.constraint(equalToConstant: 50),
            
            toCardIdTextField.topAnchor.constraint(equalTo: fromCardIdTextField.bottomAnchor, constant: 20),
            toCardIdTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            toCardIdTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            toCardIdTextField.heightAnchor.constraint(equalToConstant: 50),
            
            amountTextField.topAnchor.constraint(equalTo: toCardIdTextField.bottomAnchor, constant: 20),
            amountTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            amountTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            amountTextField.heightAnchor.constraint(equalToConstant: 50),
            
            sendButton.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 50),
            sendButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            sendButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        fromCardIdTextField.addTarget(self, action: #selector(fromCardIdTapped), for: .touchDown)
    }
    
    private func setupPickerView() {
        cardIdPickerView.dataSource = self
        cardIdPickerView.delegate = self
        
        fromCardIdTextField.inputView = cardIdPickerView
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        toolbar.barTintColor = .systemBackground
        toolbar.tintColor = .systemBlue
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexSpace, doneButton], animated: true)
        
        fromCardIdTextField.inputAccessoryView = toolbar
    }
    
    @objc private func fromCardIdTapped() {
        viewModel.fetchCards { [weak self] _ in
            self?.cardIdPickerView.reloadAllComponents()
        }
    }
    
    @objc private func doneTapped() {
        let selectedRow = cardIdPickerView.selectedRow(inComponent: 0)
        fromCardIdTextField.text = viewModel.cardIds[selectedRow]
        fromCardIdTextField.resignFirstResponder()
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    private func sendMoneyTapped() {
        guard let fromCardId = fromCardIdTextField.text,
              let toCardId = toCardIdTextField.text,
              let amountText = amountTextField.text,
              let amount = Double(amountText) else {
            showAlert(title: "Invalid Input", message: "Please check the input values.")
            return
        }
        
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

// MARK: - UIViewControllerTransitioningDelegate
extension SendMoneyViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
}

// MARK: - UIPickerViewDataSource and UIPickerViewDelegate
extension SendMoneyViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.cardIds.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.cardIds[row]
    }
}
