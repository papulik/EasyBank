//
//  CardsViewController.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 05.07.24.
//

import UIKit
import LocalAuthentication

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
    
    private lazy var transactionLabelView: HeaderLabel = {
        let view = HeaderLabel()
        view.label.text = "Transactions"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var transactionTableView: TransactionTableView = {
        let view = TransactionTableView()
        view.tableView.separatorStyle = .none
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tableView.dataSource = self
        view.tableView.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Cards"
        
        setupViews()
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchCards()
    }
    
    private func setupViews() {
        view.addSubview(collectionView)
        view.addSubview(addButton)
        view.addSubview(transactionLabelView)
        view.addSubview(transactionTableView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: 220),
            
            addButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.heightAnchor.constraint(equalToConstant: 44),
            
            transactionLabelView.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 20),
            transactionLabelView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            transactionLabelView.heightAnchor.constraint(equalToConstant: 35),
            
            transactionTableView.topAnchor.constraint(equalTo: transactionLabelView.bottomAnchor, constant: 16),
            transactionTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            transactionTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            transactionTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10)
        ])
    }
    
    private func addCardTapped() {
        let addCardVC = AddCardViewController()
        addCardVC.transitioningDelegate = self
        addCardVC.modalPresentationStyle = .custom
        addCardVC.onAddCard = { [weak self] balance, expiryDate, cardHolderName, cardType in
            self?.viewModel.addCard(balance: balance, expiryDate: expiryDate, cardHolderName: cardHolderName, type: cardType)
        }
        present(addCardVC, animated: true, completion: nil)
    }
    
    private func authenticateUser(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authenticate to view card details") { success, authenticationError in
                DispatchQueue.main.async {
                    completion(success)
                }
            }
        } else {
            let alert = UIAlertController(title: "Face ID not available", message: "Your device does not support Face ID.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            completion(false)
        }
    }
}

//MARK: - Cards Collection Extension
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
        authenticateUser { [weak self] success in
            guard let self = self else { return }
            if success {
                let card = self.viewModel.cards[indexPath.item]
                let cardDetailVC = CardDetailViewController(card: card, viewModel: self.viewModel)
                cardDetailVC.modalPresentationStyle = .custom
                self.present(cardDetailVC, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Authentication Failed", message: "You could not be verified; please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

//MARK: - Transactions TableView Extension
extension CardsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.reuseIdentifier, for: indexPath) as! TransactionTableViewCell
        let transaction = viewModel.transactions[indexPath.row]
        let fromUserName = viewModel.userNames[transaction.fromUserId] ?? transaction.fromUserId
        let toUserName = viewModel.userNames[transaction.toUserId] ?? transaction.toUserId
        cell.configure(with: transaction, fromUserName: fromUserName, toUserName: toUserName, currentUserId: viewModel.currentUser?.id ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

//MARK: - ViewModel Extension
extension CardsViewController: CardsViewModelDelegate {
    func didUpdateCards() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func didFetchTransactions() {
        DispatchQueue.main.async {
            self.transactionTableView.tableView.reloadData()
        }
    }
    
    func didEncounterError(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension CardsViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
}
