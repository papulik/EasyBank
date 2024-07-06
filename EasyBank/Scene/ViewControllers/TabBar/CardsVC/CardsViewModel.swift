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
        guard let userId = Auth.auth().currentUser?.uid else { return }
        FirestoreService.shared.getCards(forUser: userId) { [weak self] result in
            switch result {
            case .success(let cards):
                self?.cards = cards
                self?.delegate?.didUpdateCards()
            case .failure(let error):
                self?.delegate?.didEncounterError(error.localizedDescription)
            }
        }
    }
    
    func addCard(balance: Double) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let newCard = Card(id: UUID().uuidString, balance: balance)
        FirestoreService.shared.addCardToUser(userId: userId, card: newCard) { [weak self] result in
            switch result {
            case .success:
                self?.cards.append(newCard)
                self?.delegate?.didUpdateCards()
            case .failure(let error):
                self?.delegate?.didEncounterError(error.localizedDescription)
            }
        }
    }
}
