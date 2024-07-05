//
//  FirestoreService.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 30.06.24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class FirestoreService {
    static let shared = FirestoreService()
    
    private let db = Firestore.firestore()
    private let userDefaults = UserDefaults.standard
    
    private init() {}
    
    private func saveData<T: Codable>(_ data: T, forKey key: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(data) {
            print("Saving data to UserDefaults with key: \(key)")
            userDefaults.set(encoded, forKey: key)
        }
    }
    
    private func loadData<T: Codable>(forKey key: String, as type: T.Type) -> T? {
        if let savedData = userDefaults.object(forKey: key) as? Data {
            let decoder = JSONDecoder()
            if let loadedData = try? decoder.decode(type, from: savedData) {
                print("Loaded data from UserDefaults with key: \(key)")
                return loadedData
            }
        }
        return nil
    }
    
    private func removeData(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
    
    func createUser(uid: String, user: User, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try db.collection("users").document(uid).setData(from: user) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    self.saveData(user, forKey: "currentUser")
                    completion(.success(()))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func getCurrentUser(completion: @escaping (Result<User, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let docRef = db.collection("users").document(userId)
        
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                do {
                    let user = try document.data(as: User.self)
                    self.saveData(user, forKey: "currentUser")
                    completion(.success(user))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(error ?? NSError(domain: "FirestoreService", code: -1, userInfo: nil)))
            }
        }
    }
    
    func getUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        db.collection("users").getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                let users = querySnapshot?.documents.compactMap {
                    try? $0.data(as: User.self)
                } ?? []
                self.saveData(users, forKey: "users")
                completion(.success(users))
            }
        }
    }
    
    func sendMoney(fromUser: User, toUser: User, amount: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        guard fromUser.balance >= amount else {
            completion(.failure(NSError(domain: "FirestoreService", code: -2, userInfo: [NSLocalizedDescriptionKey: "Insufficient balance"])))
            return
        }
        
        let transaction = Transaction(fromUserId: fromUser.id, toUserId: toUser.id, amount: amount, timestamp: Date(), iconName: "georgia")
        
        let batch = db.batch()
        
        let fromUserRef = db.collection("users").document(fromUser.id)
        let toUserRef = db.collection("users").document(toUser.id)
        let transactionRef = db.collection("transactions").document()
        
        batch.updateData(["balance": fromUser.balance - amount], forDocument: fromUserRef)
        batch.updateData(["balance": toUser.balance + amount], forDocument: toUserRef)
        batch.setData(try! Firestore.Encoder().encode(transaction), forDocument: transactionRef)
        
        batch.commit { error in
            if let error = error {
                completion(.failure(error))
            } else {
                self.updateLocalTransactions(with: transaction)
                self.updateLocalUser(fromUser)
                self.updateLocalUser(toUser)
                completion(.success(()))
            }
        }
    }
    
    func getTransactions(forUser userId: String, completion: @escaping (Result<[Transaction], Error>) -> Void) {
        db.collection("transactions")
            .whereField("fromUserId", isEqualTo: userId)
            .getDocuments { [weak self] querySnapshot, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    let sentTransactions = querySnapshot?.documents.compactMap { try? $0.data(as: Transaction.self) } ?? []
                    self?.db.collection("transactions")
                        .whereField("toUserId", isEqualTo: userId)
                        .getDocuments { querySnapshot, error in
                            if let error = error {
                                completion(.failure(error))
                            } else {
                                let receivedTransactions = querySnapshot?.documents.compactMap { try? $0.data(as: Transaction.self) } ?? []
                                let transactions = sentTransactions + receivedTransactions
                                self?.saveData(transactions, forKey: "transactions_\(userId)")
                                completion(.success(transactions))
                            }
                        }
                }
            }
    }
    
    func getUserNames(userIds: [String], completion: @escaping (Result<[String: String], Error>) -> Void) {
        guard !userIds.isEmpty else {
            completion(.success([:]))
            return
        }
        
        db.collection("users").whereField("id", in: userIds).getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                var userNames = [String: String]()
                querySnapshot?.documents.forEach { document in
                    let user = try? document.data(as: User.self)
                    if let user = user {
                        userNames[user.id] = user.name
                    }
                }
                completion(.success(userNames))
            }
        }
    }
    
    private func updateLocalTransactions(with transaction: Transaction) {
        let userId = Auth.auth().currentUser?.uid ?? ""
        if var cachedTransactions: [Transaction] = loadData(forKey: "transactions_\(userId)", as: [Transaction].self) {
            cachedTransactions.append(transaction)
            saveData(cachedTransactions, forKey: "transactions_\(userId)")
        } else {
            saveData([transaction], forKey: "transactions_\(userId)")
        }
    }
    
    private func updateLocalUser(_ user: User) {
        if let currentUser: User = loadData(forKey: "currentUser", as: User.self), currentUser.id == user.id {
            saveData(user, forKey: "currentUser")
        }
        
        if var users: [User] = loadData(forKey: "users", as: [User].self) {
            if let index = users.firstIndex(where: { $0.id == user.id }) {
                users[index] = user
                saveData(users, forKey: "users")
            }
        }
    }
}
