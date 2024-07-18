//
//  CardCollectionViewCell.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 02.07.24.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "CardCollectionViewCell"
    
    let cardIdLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let balanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let flagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "georgia")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let cardType: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .label
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
        contentView.backgroundColor = .elementBackgrounds
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(cardIdLabel)
        contentView.addSubview(balanceLabel)
        contentView.addSubview(flagImageView)
        contentView.addSubview(cardType)
        
        NSLayoutConstraint.activate([
            flagImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            flagImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            flagImageView.heightAnchor.constraint(equalToConstant: 25),
            flagImageView.widthAnchor.constraint(equalToConstant: 25),
            
            cardType.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            cardType.leadingAnchor.constraint(equalTo: flagImageView.trailingAnchor, constant: 10),
            cardType.heightAnchor.constraint(equalToConstant: 20),
            cardType.widthAnchor.constraint(equalToConstant: 100),
            
            balanceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            balanceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            cardIdLabel.bottomAnchor.constraint(equalTo: balanceLabel.topAnchor, constant: -8),
            cardIdLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardIdLabel.widthAnchor.constraint(equalToConstant: 75),
        ])
    }
    
    func configure(with cardId: String, balance: String, type: String) {
        cardIdLabel.text = "id: \(cardId)"
        balanceLabel.text = balance
        cardType.text = type
    }
}
