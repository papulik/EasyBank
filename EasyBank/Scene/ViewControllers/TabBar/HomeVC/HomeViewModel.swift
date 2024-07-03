//
//  HomeViewModel.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 30.06.24.
//

import Foundation
import FirebaseAuth

protocol HomeViewModelDelegate: AnyObject {
    func didFetchCurrentUser(_ user: User)
    func didFetchUsers(_ users: [User])
    func didEncounterError(_ error: String)
    func didSendMoney()
    func didLogout(success: Bool)
    func didFetchTransactions(_ transactions: [Transaction])
}

class HomeViewModel {
    weak var delegate: HomeViewModelDelegate?
    
    var currentUser: User?
    var users: [User] = []
    var transactions: [Transaction] = []
    
    func fetchCurrentUser() {
        FirestoreService.shared.getCurrentUser { [weak self] result in
            switch result {
            case .success(let user):
                self?.currentUser = user
                self?.delegate?.didFetchCurrentUser(user)
                self?.fetchUsers()
                self?.fetchTransactions()
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
                self?.fetchCurrentUser()
            case .failure(let error):
                self?.delegate?.didEncounterError("Error sending money: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchTransactions() {
        guard let userId = currentUser?.id else { return }
        FirestoreService.shared.getTransactions(forUser: userId) { [weak self] result in
            switch result {
            case .success(let transactions):
                self?.transactions = transactions
                self?.delegate?.didFetchTransactions(transactions)
            case .failure(let error):
                self?.delegate?.didEncounterError("Error fetching transactions: \(error.localizedDescription)")
            }
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            delegate?.didLogout(success: true)
        } catch {
            delegate?.didLogout(success: false)
        }
    }
}
