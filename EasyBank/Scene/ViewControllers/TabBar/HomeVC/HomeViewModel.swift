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
    var userNames: [String: String] = [:]
    var contacts: [Contact] = []

    func fetchCurrentUser() {
        print("Fetching current user")
        FirestoreService.shared.getCurrentUser { [weak self] result in
            switch result {
            case .success(let user):
                self?.currentUser = user
                print("Fetched current user: \(user)")
                self?.delegate?.didFetchCurrentUser(user)
                self?.fetchUsers()
                self?.fetchTransactions()
            case .failure(let error):
                self?.delegate?.didEncounterError("Error fetching current user: \(error.localizedDescription)")
            }
        }
    }

    private func fetchUsers() {
        print("Fetching users")
        FirestoreService.shared.getUsers { [weak self] result in
            switch result {
            case .success(let users):
                self?.users = users
                print("Fetched users: \(users)")
                self?.delegate?.didFetchUsers(users)
            case .failure(let error):
                self?.delegate?.didEncounterError("Error fetching users: \(error.localizedDescription)")
            }
        }
    }

    func sendMoney(toUser: User, amount: Double) {
        guard let fromUser = currentUser else { return }
        print("Sending money from \(fromUser.email) to \(toUser.email)")
        FirestoreService.shared.sendMoney(fromUser: fromUser, toUser: toUser, amount: amount) { [weak self] result in
            switch result {
            case .success():
                print("Money sent successfully")
                self?.delegate?.didSendMoney()
                self?.fetchCurrentUser()
            case .failure(let error):
                self?.delegate?.didEncounterError("Error sending money: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchTransactions() {
        guard let userId = currentUser?.id else {
            print("Current user is nil, cannot fetch transactions")
            return
        }
        print("Fetching transactions for user id: \(userId)")
        FirestoreService.shared.getTransactions(forUser: userId) { [weak self] result in
            switch result {
            case .success(let transactions):
                print("Fetched transactions: \(transactions)")
                self?.transactions = transactions.map { transaction in
                    var transaction = transaction
                    transaction.isIncoming = (transaction.toUserId == userId)
                    return transaction
                }
                self?.sortTransactionsByDate()
                self?.fetchUserNames(for: self?.transactions ?? [])
            case .failure(let error):
                self?.delegate?.didEncounterError("Error fetching transactions: \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchUserNames(for transactions: [Transaction]) {
        let userIds = Array(Set(transactions.map { $0.fromUserId } + transactions.map { $0.toUserId }))
        print("Fetching user names for ids: \(userIds)")
        FirestoreService.shared.getUserNames(userIds: userIds) { [weak self] result in
            switch result {
            case .success(let userNames):
                print("Fetched user names: \(userNames)")
                self?.userNames = userNames
                self?.delegate?.didFetchTransactions(self?.transactions ?? [])
            case .failure(let error):
                self?.delegate?.didEncounterError("Error fetching user names: \(error.localizedDescription)")
            }
        }
    }

    private func sortTransactionsByDate() {
        transactions.sort { $0.timestamp > $1.timestamp }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            delegate?.didLogout(success: true)
        } catch {
            delegate?.didLogout(success: false)
        }
    }
    
    func generateDummyContacts() -> [Contact] {
        let dummyContacts = [
            Contact(id: UUID().uuidString, name: "Alice", imageName: "contacts1"),
            Contact(id: UUID().uuidString, name: "Bob", imageName: "contacts2"),
            Contact(id: UUID().uuidString, name: "Eve", imageName: "contacts3"),
            Contact(id: UUID().uuidString, name: "Charlie", imageName: "contacts4"),
            Contact(id: UUID().uuidString, name: "Billy", imageName: "contacts5"),
            Contact(id: UUID().uuidString, name: "Nick", imageName: "contacts6"),
            Contact(id: UUID().uuidString, name: "Loren", imageName: "contacts7"),
        ]
        return dummyContacts
    }
}
