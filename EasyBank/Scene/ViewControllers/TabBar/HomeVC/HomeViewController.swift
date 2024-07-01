//
//  HomeViewController.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 30.06.24.
//

import UIKit

class HomeViewController: UIViewController {
    private var viewModel: HomeViewModel
    weak var coordinator: AppCoordinator?
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var sendMoneyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send Money", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction { [weak self] _ in
            self?.sendMoneyTapped()
        }, for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Home"
        
        viewModel.delegate = self
        setupNavigationBar()
        setupViews()
        viewModel.fetchCurrentUser()
    }
    
    private func setupNavigationBar() {
        let logoutAction = UIAction(title: "Logout") { [weak self] _ in
            self?.logoutTapped()
        }
        let logoutBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: nil, action: nil)
        logoutBarButtonItem.primaryAction = logoutAction
        navigationItem.rightBarButtonItem = logoutBarButtonItem
    }

    private func setupViews() {
        view.addSubview(sendMoneyButton)
        
        NSLayoutConstraint.activate([
            sendMoneyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sendMoneyButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func sendMoneyTapped() {
        print("Send Money button tapped")
        guard let toUser = viewModel.users.first(where: { $0.id != viewModel.currentUser?.id }) else {
            print("No other user found to send money to")
            return
        }
        viewModel.sendMoney(toUser: toUser, amount: 10.0)
    }
    
    private func logoutTapped() {
        print("Logout button tapped")
        viewModel.logout()
    }
}

extension HomeViewController: HomeViewModelDelegate {
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
