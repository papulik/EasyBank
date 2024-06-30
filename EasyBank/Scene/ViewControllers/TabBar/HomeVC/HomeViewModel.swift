//
//  HomeViewModel.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 30.06.24.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject {
    func didFetchCurrentUser(_ user: User)
    func didFetchUsers(_ users: [User])
    func didEncounterError(_ error: String)
    func didSendMoney()
}

class HomeViewModel {
    weak var delegate: HomeViewModelDelegate?

    var currentUser: User?
    var users: [User] = []

    func fetchCurrentUser() {
        FirestoreService.shared.getCurrentUser { [weak self] result in
            switch result {
            case .success(let user):
                self?.currentUser = user
                self?.delegate?.didFetchCurrentUser(user)
                self?.fetchUsers()
            case .failure(let error):
                self?.delegate?.didEncounterError("Error fetching current user: \(error.localizedDescription)")
            }
        }
    }

    private func fetchUsers() {
        FirestoreService.shared.getUsers { [weak self] result in
            switch result {
            case .success(let users):
                self?.users = users
                self?.delegate?.didFetchUsers(users)
            case .failure(let error):
                self?.delegate?.didEncounterError("Error fetching users: \(error.localizedDescription)")
            }
        }
    }

    func sendMoney(toUser: User, amount: Double) {
        guard let fromUser = currentUser else { return }
        FirestoreService.shared.sendMoney(fromUser: fromUser, toUser: toUser, amount: amount) { [weak self] result in
            switch result {
            case .success():
                self?.delegate?.didSendMoney()
                self?.fetchCurrentUser() // Refresh user data after transaction
            case .failure(let error):
                self?.delegate?.didEncounterError("Error sending money: \(error.localizedDescription)")
            }
        }
    }
}
