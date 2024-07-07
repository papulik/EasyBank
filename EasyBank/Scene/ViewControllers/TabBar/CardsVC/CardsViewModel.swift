//
//  CardsViewModel.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 05.07.24.
//

import Foundation
import FirebaseAuth

protocol CardsViewModelDelegate: AnyObject {
    func didUpdateCards()
    func didEncounterError(_ error: String)
}

class CardsViewModel {
    weak var delegate: CardsViewModelDelegate?
    
    var cards: [Card] = []
    
    func fetchCards() {
        guard (Auth.auth().currentUser?.uid) != nil else { return }
        FirestoreService.shared.getCurrentUser { [weak self] result in
            switch result {
            case .success(let user):
                self?.cards = user.cards
                self?.delegate?.didUpdateCards()
            case .failure(let error):
                self?.delegate?.didEncounterError(error.localizedDescription)
            }
        }
    }
    
    func addCard(balance: Double, expiryDate: String, cardHolderName: String, type: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let newCard = Card(id: UUID().uuidString, balance: balance, expiryDate: expiryDate, cardHolderName: cardHolderName, type: type)
        FirestoreService.shared.getCurrentUser { [weak self] result in
            switch result {
            case .success(var user):
                user.cards.append(newCard)
                FirestoreService.shared.createUser(uid: userId, user: user) { result in
                    switch result {
                    case .success:
                        self?.cards.append(newCard)
                        self?.delegate?.didUpdateCards()
                    case .failure(let error):
                        self?.delegate?.didEncounterError(error.localizedDescription)
                    }
                }
            case .failure(let error):
                self?.delegate?.didEncounterError(error.localizedDescription)
            }
        }
    }
    
    func deleteCard(cardId: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        FirestoreService.shared.deleteCard(forUser: userId, cardId: cardId) { [weak self] result in
            switch result {
            case .success:
                self?.cards.removeAll { $0.id == cardId }
                self?.delegate?.didUpdateCards()
            case .failure(let error):
                self?.delegate?.didEncounterError(error.localizedDescription)
            }
        }
    }
    
    func updateCardDetails(cardId: String, newBalance: Double, newExpiryDate: String, newCardHolderName: String, newType: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        FirestoreService.shared.updateCardDetails(forUser: userId, cardId: cardId, newBalance: newBalance, newExpiryDate: newExpiryDate, newCardHolderName: newCardHolderName, newType: newType) { [weak self] result in
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
