//
//  CurrencyViewModel.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 12.07.24.
//

import Foundation
import SimpleNetworking

protocol CurrencyViewModelDelegate: AnyObject {
    func didUpdateCurrencies()
    func didEncounterError(_ error: String)
}

class CurrencyViewModel {
    weak var delegate: CurrencyViewModelDelegate?
    
    private var allCurrencies: [Currency] = []
    var currenciesGrouped: [String: [Currency]] = [:]
    var sectionTitles: [String] = []
    
    func fetchCurrencies() {
        let urlString = "\(Constants.API.currencyAPIBaseURL)\(Constants.API.ratesEndpoint)?apikey=\(Constants.API.currencyAPIKey)"
        guard let url = URL(string: urlString) else { return }
        
        NetworkingService.shared.fetchData(from: url) { (result: Result<CurrencyAPIResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.allCurrencies = response.rates.compactMap { key, value in
                        guard let rate = Double(value) else { return nil }
                        return Currency(code: key, name: self.currencyName(for: key), rate: rate, iconURL: self.iconURL(for: key))
                    }
                    self.filterCurrencies(with: "")
                case .failure(let error):
                    self.delegate?.didEncounterError(error.localizedDescription)
                }
            }
        }
    }
    
    func filterCurrencies(with searchText: String) {
        if searchText.isEmpty {
            currenciesGrouped = Dictionary(grouping: allCurrencies, by: { String($0.name.prefix(1)) })
        } else {
            currenciesGrouped = Dictionary(grouping: allCurrencies.filter { $0.code.lowercased().contains(searchText.lowercased()) || $0.name.lowercased().contains(searchText.lowercased()) }, by: { String($0.name.prefix(1)) })
        }
        sectionTitles = currenciesGrouped.keys.sorted()
        delegate?.didUpdateCurrencies()
    }
    
    private func currencyName(for code: String) -> String {
        return Locale.current.localizedString(forCurrencyCode: code) ?? code
    }
    
    private func iconURL(for code: String) -> String {
        return "https://currencyfreaks.com/photos/flags/\(code.lowercased()).png"
    }
}
