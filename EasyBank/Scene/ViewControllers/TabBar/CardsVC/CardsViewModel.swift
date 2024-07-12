//
//  CardsViewModel.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 05.07.24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol CardsViewModelDelegate: AnyObject {
    func didUpdateCards()
    func didFetchTransactions()
    func didEncounterError(_ error: String)
}

class CardsViewModel {
    weak var delegate: CardsViewModelDelegate?
    
    var cards: [Card] = []
    var transactions: [Transaction] = []
    var userNames: [String: String] = [:]
    var currentUser: User?
    
    private var userListener: ListenerRegistration?
    private var transactionsListener: ListenerRegistration?
    
    deinit {
        userListener?.remove()
        transactionsListener?.remove()
    }
    
    func fetchCards() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        userListener = Firestore.firestore().collection("users").document(userId).addSnapshotListener { [weak self] documentSnapshot, error in
            guard let self = self else { return }
            if let error = error {
                DispatchQueue.main.async {
                    self.delegate?.didEncounterError(error.localizedDescription)
                }
                return
            }
            
            guard let document = documentSnapshot, document.exists, let user = try? document.data(as: User.self) else {
                DispatchQueue.main.async {
                    self.delegate?.didEncounterError("User data not found")
                }
                return
            }
            
            DispatchQueue.main.async {
                self.currentUser = user
                self.cards = user.cards
                self.delegate?.didUpdateCards()
                self.fetchTransactions()
            }
        }
    }
    
    func addCard(balance: Double, expiryDate: String, cardHolderName: String, type: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let newCard = Card(id: UUID().uuidString, balance: balance, expiryDate: expiryDate, cardHolderName: cardHolderName, type: type)
        
        FirestoreService.shared.getCurrentUser { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(var user):
                    if user.cards.contains(where: { $0.id == newCard.id }) {
                        return
                    }
                    
                    self?.userListener?.remove()
                    
                    user.cards.append(newCard)
                    FirestoreService.shared.createUser(uid: userId, user: user) { result in
                        DispatchQueue.main.async {
                            self?.fetchCards()
                            
                            switch result {
                            case .success:
                                self?.cards.append(newCard)
                                self?.delegate?.didUpdateCards()
                            case .failure(let error):
                                self?.delegate?.didEncounterError(error.localizedDescription)
                            }
                        }
                    }
                case .failure(let error):
                    self?.delegate?.didEncounterError(error.localizedDescription)
                }
            }
        }
    }
    
    func deleteCard(cardId: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        FirestoreService.shared.deleteCard(forUser: userId, cardId: cardId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.cards.removeAll { $0.id == cardId }
                    self?.delegate?.didUpdateCards()
                case .failure(let error):
                    self?.delegate?.didEncounterError(error.localizedDescription)
                }
            }
        }
    }
    
    func updateCardDetails(cardId: String, newBalance: Double, newExpiryDate: String, newCardHolderName: String, newType: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        FirestoreService.shared.updateCardDetails(forUser: userId, cardId: cardId, newBalance: newBalance, newExpiryDate: newExpiryDate, newCardHolderName: newCardHolderName, newType: newType) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    if let index = self?.cards.firstIndex(where: { $0.id == cardId }) {
                        self?.cards[index].balance = newBalance
                        self?.cards[index].expiryDate = newExpiryDate
                        self?.cards[index].cardHolderName = newCardHolderName
                        self?.cards[index].type = newType
                        self?.delegate?.didUpdateCards()
                    }
                case .failure(let error):
                    self?.delegate?.didEncounterError(error.localizedDescription)
                }
            }
        }
    }
    
    func fetchTransactions() {
        guard let userId = currentUser?.id else { return }
        transactionsListener = Firestore.firestore().collection("transactions")
            .whereField("fromUserId", isEqualTo: userId)
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let self = self else { return }
                if let error = error {
                    DispatchQueue.main.async {
                        self.delegate?.didEncounterError(error.localizedDescription)
                    }
                    return
                }
                
                var transactions: [Transaction] = []
                
                querySnapshot?.documents.forEach { document in
                    if let transaction = try? document.data(as: Transaction.self) {
                        transactions.append(transaction)
                    }
                }
                
                Firestore.firestore().collection("transactions")
                    .whereField("toUserId", isEqualTo: userId)
                    .addSnapshotListener { [weak self] querySnapshot, error in
                        guard let self = self else { return }
                        if let error = error {
                            DispatchQueue.main.async {
                                self.delegate?.didEncounterError(error.localizedDescription)
                            }
                            return
                        }
                        
                        querySnapshot?.documents.forEach { document in
                            if let transaction = try? document.data(as: Transaction.self) {
                                transactions.append(transaction)
                            }
                        }
                        
                        DispatchQueue.main.async {
                            self.transactions = transactions.map { transaction in
                                var transaction = transaction
                                transaction.isIncoming = (transaction.toUserId == userId)
                                return transaction
                            }
                            self.sortTransactionsByDate()
                            self.fetchUserNames(for: self.transactions)
                        }
                    }
            }
    }
    
    private func fetchUserNames(for transactions: [Transaction]) {
        let userIds = Array(Set(transactions.map { $0.fromUserId } + transactions.map { $0.toUserId }))
        FirestoreService.shared.getUserNames(userIds: userIds) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userNames):
                    self?.userNames = userNames
                    self?.delegate?.didFetchTransactions()
                case .failure(let error):
                    self?.delegate?.didEncounterError("Error fetching user names: \(error.localizedDescription)")
                }
            }
        }
    }

    private func sortTransactionsByDate() {
        transactions.sort { $0.timestamp > $1.timestamp }
    }
}
