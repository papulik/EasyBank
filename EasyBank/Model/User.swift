//
//  User.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 30.06.24.
//

import Foundation

struct User: Codable {
    let id: String
    let email: String
    let name: String
    var cards: [Card]
}

struct Card: Codable {
    let id: String
    var balance: Double
    var expiryDate: String
    var cardHolderName: String
    var type: String
}
