//
//  CustomTextFieldView.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 29.06.24.
//

import UIKit

class CustomUITextField: UITextField {
    var isValid: Bool = true {
        didSet {
            updateBorder()
        }
    }

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
        self.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        updateBorder()
    }

    @objc private func textFieldDidChange() {
        updateBorder()
    }

    private func updateBorder() {
        self.layer.borderColor = isValid ? UIColor.clear.cgColor : UIColor.red.cgColor
    }
}
