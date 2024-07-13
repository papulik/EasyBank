//
//  Currency.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 13.07.24.
//

import Foundation

struct Currency {
    let code: String
    let name: String
    let rate: Double
    let iconURL: String
}

struct CurrencyAPIResponse: Codable {
    let date: String
    let base: String
    let rates: [String: String]
}
