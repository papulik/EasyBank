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
    
    private let fromCardIdTextField = CustomTextField(placeholder: "From Card ID")
    private let toCardIdTextField = CustomTextField(placeholder: "To Card ID")
    private let amountTextField = CustomTextField(placeholder: "Amount", keyboardType: .decimalPad)
    
    private lazy var sendButton: TabBarsCustomButton = {
        let button = TabBarsCustomButton(title: "Send Money", action: UIAction { [weak self] _ in
            self?.sendMoneyTapped()
        })
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
    }
    
    private func setupViews() {
        let closeButton = DismissButton()
        
        view.addSubview(closeButton)
        view.addSubview(fromCardIdTextField)
        view.addSubview(toCardIdTextField)
        view.addSubview(amountTextField)
        view.addSubview(sendButton)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.heightAnchor.constraint(equalToConstant: 40),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            
            fromCardIdTextField.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 20),
            fromCardIdTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            fromCardIdTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            toCardIdTextField.topAnchor.constraint(equalTo: fromCardIdTextField.bottomAnchor, constant: 20),
            toCardIdTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            toCardIdTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            amountTextField.topAnchor.constraint(equalTo: toCardIdTextField.bottomAnchor, constant: 20),
            amountTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            amountTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            sendButton.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 20),
            sendButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            sendButton.heightAnchor.constraint(equalToConstant: 44)
        ])
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
