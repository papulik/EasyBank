//
//  TransactionLabelView.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 02.07.24.
//

import UIKit

class TransactionLabelView: UIView {
    
    private(set) lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Transactions"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.heightAnchor.constraint(equalToConstant: 30),
            label.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
}

