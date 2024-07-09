//
//  CardsViewController.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 05.07.24.
//

import UIKit

class CardsViewController: UIViewController {
    private var viewModel: CardsViewModel
    weak var coordinator: AppCoordinator?
    
    init(viewModel: CardsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var addButton: TabBarsCustomButton = {
        let action = UIAction { [weak self] _ in
            self?.addCardTapped()
        }
        let button = TabBarsCustomButton(title: "Add Card", action: action)
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 300, height: 200)
        layout.minimumLineSpacing = 16
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CardCollectionRollCell.self, forCellWithReuseIdentifier: CardCollectionRollCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Cards"
        
        setupViews()
        viewModel.delegate = self
        viewModel.fetchCards()
    }
    
    private func setupViews() {
        view.addSubview(addButton)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: 220),
            
            addButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    private func addCardTapped() {
        let alert = UIAlertController(title: "Add Card", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Initial Balance"
            textField.keyboardType = .decimalPad
        }
        alert.addTextField { textField in
            textField.placeholder = "Expiry Date"
        }
        alert.addTextField { textField in
            textField.placeholder = "Card Holder Name"
        }
        alert.addTextField { textField in
            textField.placeholder = "Card Type"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let self = self else { return }
            if let balanceText = alert.textFields?[0].text, let balance = Double(balanceText),
               let expiryDate = alert.textFields?[1].text,
               let cardHolderName = alert.textFields?[2].text,
               let type = alert.textFields?[3].text {
                self.viewModel.addCard(balance: balance, expiryDate: expiryDate, cardHolderName: cardHolderName, type: type)
            }
        })
        present(alert, animated: true, completion: nil)
    }
}

extension CardsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionRollCell.reuseIdentifier, for: indexPath) as! CardCollectionRollCell
        let card = viewModel.cards[indexPath.item]
        cell.configure(with: card)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let card = viewModel.cards[indexPath.item]
        let cardDetailVC = CardDetailViewController(card: card, viewModel: viewModel)
        cardDetailVC.modalPresentationStyle = .custom
        present(cardDetailVC, animated: true, completion: nil)
    }
}

extension CardsViewController: CardsViewModelDelegate {
    func didUpdateCards() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func didEncounterError(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
