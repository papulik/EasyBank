//
//  CustomSecureFieldView.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 29.06.24.
//

import UIKit

class CustomSecureUITextField: UITextField {
    var isSecure: Bool = true {
        didSet {
            updateSecureTextEntry()
        }
    }
    var isValid: Bool = true {
        didSet {
            updateBorder()
        }
    }

    private let toggleButton = UIButton(type: .custom)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        self.borderStyle = .roundedRect
        self.layer.cornerRadius = 5.0
        self.layer.borderWidth = 1.0
        self.isSecureTextEntry = isSecure

        toggleButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        toggleButton.setImage(UIImage(systemName: "eye.fill"), for: .selected)
        toggleButton.tintColor = .gray
        toggleButton.addTarget(self, action: #selector(toggleSecureEntry), for: .touchUpInside)

        let container = UIView()
        container.addSubview(toggleButton)
        toggleButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toggleButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
            toggleButton.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            toggleButton.widthAnchor.constraint(equalToConstant: 24),
            toggleButton.heightAnchor.constraint(equalToConstant: 24)
        ])

        self.rightView = container
        self.rightViewMode = .always
        container.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            container.widthAnchor.constraint(equalToConstant: 44),
            container.heightAnchor.constraint(equalToConstant: 44)
        ])

        self.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        updateBorder()
    }

    @objc private func toggleSecureEntry() {
        isSecure.toggle()
        toggleButton.isSelected = !isSecure
    }

    @objc private func textFieldDidChange() {
        updateBorder()
    }

    private func updateBorder() {
        self.layer.borderColor = isValid ? UIColor.clear.cgColor : UIColor.red.cgColor
    }

    private func updateSecureTextEntry() {
        self.isSecureTextEntry = isSecure
    }
}
