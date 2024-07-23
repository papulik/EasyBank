//
//  CurrencyTableViewCell.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 13.07.24.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {
    static let reuseIdentifier = "CurrencyTableViewCell"
    
    private let currencyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let currencyCodeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let currencyNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let currencyRateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(currencyImageView)
        contentView.addSubview(currencyCodeLabel)
        contentView.addSubview(currencyNameLabel)
        contentView.addSubview(currencyRateLabel)
        
        NSLayoutConstraint.activate([
            currencyImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            currencyImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            currencyImageView.widthAnchor.constraint(equalToConstant: 40),
            currencyImageView.heightAnchor.constraint(equalToConstant: 40),
            
            currencyCodeLabel.leadingAnchor.constraint(equalTo: currencyImageView.trailingAnchor, constant: 16),
            currencyCodeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            
            currencyNameLabel.leadingAnchor.constraint(equalTo: currencyCodeLabel.leadingAnchor),
            currencyNameLabel.topAnchor.constraint(equalTo: currencyCodeLabel.bottomAnchor, constant: 4),
            currencyNameLabel.widthAnchor.constraint(equalToConstant: 100),
            
            currencyRateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            currencyRateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            currencyRateLabel.widthAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    func configure(with currency: Currency) {
        currencyCodeLabel.text = currency.code
        currencyNameLabel.text = currency.name
        currencyRateLabel.text = "$ \(String(format: "%.3f", currency.rate))"
        if let url = URL(string: currency.iconURL) {
            currencyImageView.loadImage(from: url, placeholder: UIImage(named: "georgia"))
        }
    }
}

