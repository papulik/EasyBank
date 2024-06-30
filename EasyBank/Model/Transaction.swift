//
//  Transaction.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 30.06.24.
//

import Foundation

struct Transaction: Codable {
    let fromUserId: String
    let toUserId: String
    let amount: Double
    let timestamp: Date
}
