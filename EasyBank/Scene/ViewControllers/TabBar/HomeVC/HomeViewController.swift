//
//  HomeViewController.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 30.06.24.
//

import UIKit

class HomeViewController: UIViewController, HomeViewModelDelegate {
    private var viewModel = HomeViewModel()

    private let sendMoneyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send Money", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        viewModel.delegate = self
        setupViews()
        viewModel.fetchCurrentUser()
    }

    private func setupViews() {
        view.addSubview(sendMoneyButton)
        sendMoneyButton.addTarget(self, action: #selector(sendMoneyTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            sendMoneyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sendMoneyButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func sendMoneyTapped() {
        guard let toUser = viewModel.users.first(where: { $0.id != viewModel.currentUser?.id }) else {
            print("No other user found to send money to")
            return
        }
        viewModel.sendMoney(toUser: toUser, amount: 10.0)
    }

    // MARK: - HomeViewModelDelegate

    func didFetchCurrentUser(_ user: User) {
        print("Current User: \(user)")
    }

    func didFetchUsers(_ users: [User]) {
        print("Fetched Users: \(users)")
    }

    func didEncounterError(_ error: String) {
        print(error)
    }

    func didSendMoney() {
        print("Money sent successfully")
    }
}
