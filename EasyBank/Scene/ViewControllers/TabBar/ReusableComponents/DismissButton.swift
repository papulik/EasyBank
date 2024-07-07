//
//  DismissButton.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 07.07.24.
//

import UIKit

class DismissButton: UIButton {
    init() {
        super.init(frame: .zero)
        setTitle("X", for: .normal)
        setTitleColor(.white, for: .normal)
        backgroundColor = .systemRed
        layer.cornerRadius = 10
        translatesAutoresizingMaskIntoConstraints = false
        addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func dismissTapped() {
        guard let parentViewController = self.findViewController() else {
            return
        }
        parentViewController.dismiss(animated: true, completion: nil)
    }
    
    private func findViewController() -> UIViewController? {
        if var nextResponder = self.next {
            while !(nextResponder is UIViewController) {
                if let next = nextResponder.next {
                    nextResponder = next
                } else {
                    return nil
                }
            }
            return nextResponder as? UIViewController
        }
        return nil
    }
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.systemRed.withAlphaComponent(0.7) : .systemRed
        }
    }
}
