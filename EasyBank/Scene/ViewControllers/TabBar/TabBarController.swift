//
//  TabBarController.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 30.06.24.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        
        viewControllers = [homeVC]
    }
}

import UIKit

class HomeViewController: UIViewController {
    private let sendMoneyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send Money", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(sendMoneyButton)
        sendMoneyButton.addTarget(self, action: #selector(sendMoneyTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            sendMoneyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sendMoneyButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func sendMoneyTapped() {
        FirestoreService.shared.getCurrentUser { [weak self] result in
            switch result {
            case .success(let currentUser):
                print("Current User: \(currentUser)")
                FirestoreService.shared.getUsers { result in
                    switch result {
                    case .success(let users):
                        print("Fetched Users: \(users)")
                        guard let toUser = users.first(where: { $0.id != currentUser.id }) else {
                            print("No other user found to send money to")
                            return
                        }
                        FirestoreService.shared.sendMoney(fromUser: currentUser, toUser: toUser, amount: 10.0) { result in
                            switch result {
                            case .success():
                                print("Money sent successfully")
                            case .failure(let error):
                                print("Error sending money: \(error)")
                            }
                        }
                    case .failure(let error):
                        print("Error fetching users: \(error)")
                    }
                }
            case .failure(let error):
                print("Error fetching current user: \(error)")
            }
        }
    }
}
