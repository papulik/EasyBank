//
//  TransactionTableView.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 02.07.24.
//

import UIKit

class TransactionTableView: UIView {
    let tableView: UITableView
    let noTransactionsLabel: UILabel = {
        let label = UILabel()
        label.text = "No transactions yet"
        label.textColor = .lightGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()

    override init(frame: CGRect) {
        tableView = UITableView()
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: TransactionTableViewCell.reuseIdentifier)
        
        addSubview(tableView)
        addSubview(noTransactionsLabel)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),

            noTransactionsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            noTransactionsLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
