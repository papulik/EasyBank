//
//  TransactionTableViewCell.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 02.07.24.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    static let reuseIdentifier = "TransactionTableViewCell"
    
    private let transactionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(transactionLabel)
        contentView.addSubview(amountLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 40),
            
            transactionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            transactionLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            
            amountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func configure(with transaction: Transaction) {
        transactionLabel.text = transaction.toUserId
        amountLabel.text = String(transaction.amount)
        if let iconName = transaction.iconName, let image = UIImage(named: iconName) {
            iconImageView.image = image
        } else {
            iconImageView.image = UIImage(systemName: "photo")
        }
    }
}
