//
//  CardCollectionRollCell.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 06.07.24.
//

import UIKit

class CardCollectionRollCell: UICollectionViewCell {
    static let reuseIdentifier = "CardCollectionRollCell"
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "CardBackGroundImage")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cardIdLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cardHolderNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let balanceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let expiryDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
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
        contentView.addSubview(backgroundImageView)
        contentView.addSubview(typeLabel)
        contentView.addSubview(cardIdLabel)
        contentView.addSubview(cardHolderNameLabel)
        contentView.addSubview(balanceLabel)
        contentView.addSubview(expiryDateLabel)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            typeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            typeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            cardIdLabel.centerYAnchor.constraint(equalTo: typeLabel.centerYAnchor),
            cardIdLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            cardHolderNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            cardHolderNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            balanceLabel.bottomAnchor.constraint(equalTo: cardHolderNameLabel.topAnchor, constant: -8),
            balanceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            expiryDateLabel.bottomAnchor.constraint(equalTo: balanceLabel.topAnchor, constant: -8),
            expiryDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
    }
    
    func configure(with card: Card) {
        typeLabel.text = card.type
        cardIdLabel.text = "****\(card.id.suffix(4))"
        balanceLabel.text = "Balance: \(card.balance) ₾"
        expiryDateLabel.text = "Expiry: \(card.expiryDate)"
        cardHolderNameLabel.text = card.cardHolderName
    }
}
