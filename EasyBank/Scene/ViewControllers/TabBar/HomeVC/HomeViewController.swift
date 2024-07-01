//
//  HomeViewController.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 30.06.24.
//

import UIKit

class HomeViewController: UIViewController, HomeViewModelDelegate {
    private var viewModel: HomeViewModel
    weak var coordinator: AppCoordinator?

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let sendMoneyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send Money", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.systemRed, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Home"

        viewModel.delegate = self
        setupViews()
        viewModel.fetchCurrentUser()
    }

    private func setupViews() {
        view.addSubview(sendMoneyButton)
        view.addSubview(logoutButton)
        sendMoneyButton.addTarget(self, action: #selector(sendMoneyTapped), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            sendMoneyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sendMoneyButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }

    @objc private func sendMoneyTapped() {
        print("Send Money button tapped")
        guard let toUser = viewModel.users.first(where: { $0.id != viewModel.currentUser?.id }) else {
            print("No other user found to send money to")
            return
        }
        viewModel.sendMoney(toUser: toUser, amount: 10.0)
    }

    @objc private func logoutTapped() {
        print("Logout button tapped")
        viewModel.logout()
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

    func didLogout(success: Bool) {
        if success {
            coordinator?.showLogin()
        } else {
            print("Logout failed")
        }
    }
}
