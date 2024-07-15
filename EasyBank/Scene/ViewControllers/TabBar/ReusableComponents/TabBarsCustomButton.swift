//
//  TabBarsCustomButton.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 06.07.24.
//

import UIKit

class TabBarsCustomButton: UIButton {

    private var normalBackgroundColor: UIColor = .systemPurple

    init(title: String, action: UIAction? = nil, backgroundColor: UIColor = .systemBlue) {
        self.normalBackgroundColor = backgroundColor
        super.init(frame: .zero)
        setupButton(title: title, action: action)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupButton(title: String, action: UIAction?) {
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        self.backgroundColor = normalBackgroundColor
        layer.cornerRadius = 10
        titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        translatesAutoresizingMaskIntoConstraints = false
        if let action = action {
            addAction(action, for: .touchUpInside)
        }
    }

    override var isHighlighted: Bool {
        didSet {
            backgroundColor = normalBackgroundColor.withAlphaComponent(isHighlighted ? 0.7 : 1.0)
        }
    }
}
