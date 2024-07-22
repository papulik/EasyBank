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
    
    private let editIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "pencil.circle.fill")
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupHighlightEffect()
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
        contentView.addSubview(editIcon)
        contentView.addSubview(overlayView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            overlayView.topAnchor.constraint(equalTo: contentView.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            typeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            typeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            cardIdLabel.centerYAnchor.constraint(equalTo: typeLabel.centerYAnchor),
            cardIdLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            cardHolderNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            cardHolderNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            balanceLabel.bottomAnchor.constraint(equalTo: cardHolderNameLabel.topAnchor, constant: -8),
            balanceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            expiryDateLabel.bottomAnchor.constraint(equalTo: balanceLabel.topAnchor, constant: -8),
            expiryDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            editIcon.centerYAnchor.constraint(equalTo: typeLabel.centerYAnchor),
            editIcon.trailingAnchor.constraint(equalTo: cardIdLabel.leadingAnchor, constant: -8),
            editIcon.widthAnchor.constraint(equalToConstant: 30),
            editIcon.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setupHighlightEffect() {
        let highlightView = UIView()
        highlightView.backgroundColor = UIColor.green.withAlphaComponent(1.0)
        highlightView.layer.cornerRadius = 10
        highlightView.layer.shadowColor = UIColor.green.cgColor
        highlightView.layer.shadowOpacity = 0.7
        highlightView.layer.shadowOffset = CGSize(width: 0, height: 4)
        highlightView.layer.shadowRadius = 5

        selectedBackgroundView = highlightView
    }
    
    func configure(with card: Card) {
        typeLabel.text = card.type
        cardIdLabel.text = "****\(card.id.suffix(4))"
        balanceLabel.text = "Balance: \(card.balance) ₾"
        expiryDateLabel.text = "Expiry: \(card.expiryDate)"
        cardHolderNameLabel.text = card.cardHolderName
    }
}
