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
    
    private lazy var transactionLabelView: TransactionLabelView = {
        let view = TransactionLabelView()
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
    
    private var transactions: [Transaction] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Home"
        
        viewModel.delegate = self
        setupNavigationBar()
        setupViews()
        viewModel.fetchCurrentUser()
    }
    
    //MARK: - Setup Navigation Bar LogOut Button with Alert
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

    //MARK: - Setup UI
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(cardCollectionView)
        contentView.addSubview(sendMoneyButtonView)
        contentView.addSubview(transactionLabelView)
        contentView.addSubview(transactionTableView)
        
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
            
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: transactionTableView.bottomAnchor, constant: 20)
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

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.reuseIdentifier, for: indexPath) as! CardCollectionViewCell
        cell.configure(with: "🏦 123456789012345\(indexPath.row)", balance: "$710.20", imageName: "georgia")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 150)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.reuseIdentifier, for: indexPath) as! TransactionTableViewCell
        let transaction = transactions[indexPath.row]
        cell.configure(with: transaction)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

//MARK: - HomeViewModelDelegate Methods
extension HomeViewController: HomeViewModelDelegate {
    func didFetchCurrentUser(_ user: User) {
        print("Current User: \(user)")
    }
    
    func didFetchUsers(_ users: [User]) {
        print("Fetched Users: \(users)")
    }
    
    func didEncounterError(_ error: String) {
        print(error)
    }
    
    func didSendMoney() {
        print("Money sent successfully")
        viewModel.fetchTransactions()
    }
    
    func didFetchTransactions(_ transactions: [Transaction]) {
        self.transactions = transactions
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
