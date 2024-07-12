//
//  TransactionTableView.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 02.07.24.
//

import UIKit

class TransactionTableView: UIView {
    let tableView: UITableView
    
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
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
