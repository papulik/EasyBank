//
//  HomeViewController.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 30.06.24.
//

import UIKit

class HomeViewController: UIViewController {
    private var viewModel: HomeViewModel
    weak var coordinator: AppCoordinator?
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var cardCollectionView: CardCollectionView = {
        let view = CardCollectionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.collectionView.dataSource = self
        view.collectionView.delegate = self
        view.collectionView.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: CardCollectionViewCell.reuseIdentifier)
        return view
    }()
    
    private lazy var sendMoneyButtonView: SendMoneyButtonView = {
        let view = SendMoneyButtonView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.button.addAction(UIAction { [weak self] _ in
            self?.sendMoneyTapped()
        }, for: .touchUpInside)
        return view
    }()
    
    private lazy var transactionLabelView: HeaderLabel = {
        let view = HeaderLabel()
        view.label.text = "Transactions"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var transactionTableView: TransactionTableView = {
        let view = TransactionTableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tableView.dataSource = self
        view.tableView.delegate = self
        return view
    }()
    
    private lazy var recentContactsLabelView: HeaderLabel = {
        let view = HeaderLabel()
        view.label.text = "Recent Contacts"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var contactsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 60, height: 80)
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ContactCollectionViewCell.self, forCellWithReuseIdentifier: ContactCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Home"
        
        viewModel.delegate = self
        setupNavigationBar()
        setupViews()
        viewModel.fetchCurrentUser()
        viewModel.contacts = viewModel.generateDummyContacts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if viewModel.currentUser != nil {
            viewModel.fetchTransactions()
        } else {
            viewModel.fetchCurrentUser()
        }
    }
    
    private func setupNavigationBar() {
        let logoutAction = UIAction(image: UIImage(systemName: "arrow.left.square")) { [weak self] _ in
            guard let self = self else { return }
            let alert = UIAlertController(title: "Logging Out", message: "Are you sure you want to log out of the EB App ⚠️", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            
            let confirmAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
                self.logoutTapped()
            }
            alert.addAction(confirmAction)
            
            self.present(alert, animated: true, completion: nil)
        }
        
        let logoutBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left.square"), style: .plain, target: nil, action: nil)
        logoutBarButtonItem.primaryAction = logoutAction
        navigationItem.rightBarButtonItem = logoutBarButtonItem
    }

    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(cardCollectionView)
        contentView.addSubview(sendMoneyButtonView)
        contentView.addSubview(transactionLabelView)
        contentView.addSubview(transactionTableView)
        contentView.addSubview(recentContactsLabelView)
        contentView.addSubview(contactsCollectionView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            cardCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            cardCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardCollectionView.heightAnchor.constraint(equalToConstant: 180),
            
            sendMoneyButtonView.topAnchor.constraint(equalTo: cardCollectionView.bottomAnchor, constant: 16),
            sendMoneyButtonView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            sendMoneyButtonView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            sendMoneyButtonView.heightAnchor.constraint(equalToConstant: 44),
            
            transactionLabelView.topAnchor.constraint(equalTo: sendMoneyButtonView.bottomAnchor, constant: 20),
            transactionLabelView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            transactionLabelView.heightAnchor.constraint(equalToConstant: 35),
            
            transactionTableView.topAnchor.constraint(equalTo: transactionLabelView.bottomAnchor, constant: 5),
            transactionTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            transactionTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            transactionTableView.heightAnchor.constraint(equalToConstant: 250),
            
            recentContactsLabelView.topAnchor.constraint(equalTo: transactionTableView.bottomAnchor, constant: 16),
            recentContactsLabelView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            recentContactsLabelView.heightAnchor.constraint(equalToConstant: 35),
            
            contactsCollectionView.topAnchor.constraint(equalTo: recentContactsLabelView.bottomAnchor, constant: 10),
            contactsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contactsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            contactsCollectionView.heightAnchor.constraint(equalToConstant: 80),
            
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: contactsCollectionView.bottomAnchor, constant: 20)
        ])
    }
    
    private func sendMoneyTapped() {
        print("Send Money button tapped")
        guard let toUser = viewModel.users.first(where: { $0.id != viewModel.currentUser?.id }) else {
            print("No other user found to send money to")
            return
        }
        viewModel.sendMoney(toUser: toUser, amount: 10.0)
    }
    
    private func logoutTapped() {
        viewModel.logout()
    }
}

// MARK: - Card Collection View DataSource and Delegate
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cardCollectionView.collectionView {
            return 1
        } else {
            return viewModel.contacts.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == cardCollectionView.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.reuseIdentifier, for: indexPath) as! CardCollectionViewCell
            if let currentUser = viewModel.currentUser {
                cell.configure(with: currentUser.id, balance: String(format: "%.2f", currentUser.balance))
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContactCollectionViewCell.reuseIdentifier, for: indexPath) as! ContactCollectionViewCell
            let contact = viewModel.contacts[indexPath.item]
            cell.configure(with: contact)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == cardCollectionView.collectionView {
            return CGSize(width: 200, height: 150)
        } else {
            return CGSize(width: 60, height: 80)
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
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

// MARK: - HomeViewModelDelegate
extension HomeViewController: HomeViewModelDelegate {
    func didFetchCurrentUser(_ user: User) {
        print("Current User: \(user)")
        cardCollectionView.collectionView.reloadData()
        contactsCollectionView.reloadData()
    }
    
    func didFetchUsers(_ users: [User]) {
        print("Fetched Users: \(users)")
        contactsCollectionView.reloadData()
    }
    
    func didEncounterError(_ error: String) {
        print(error)
    }
    
    func didSendMoney() {
        print("Money sent successfully")
    }
    
    func didFetchTransactions(_ transactions: [Transaction]) {
        viewModel.transactions = transactions.sorted { $0.timestamp > $1.timestamp }
        transactionTableView.tableView.reloadData()
    }
    
    func didLogout(success: Bool) {
        if success {
            coordinator?.showLogin()
        } else {
            print("Logout failed")
        }
    }
}
