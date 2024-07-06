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
            userDefaults.set(encoded, forKey: key)
        }
    }
    
    private func loadData<T: Codable>(forKey key: String, as type: T.Type) -> T? {
        if let savedData = userDefaults.object(forKey: key) as? Data {
            let decoder = JSONDecoder()
            if let loadedData = try? decoder.decode(type, from: savedData) {
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
    
    func sendMoney(fromCardId: String, toCardId: String, amount: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        print("Initiating sendMoney from \(fromCardId) to \(toCardId) amount \(amount)")
        
        let usersCollection = db.collection("users")
        
        usersCollection.getDocuments { querySnapshot, error in
            if let error = error {
                print("Error fetching users: \(error)")
                completion(.failure(error))
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No users found")
                completion(.failure(NSError(domain: "FirestoreService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No users found"])))
                return
            }
            
            var fromUser: User?
            var toUser: User?
            var fromUserDoc: DocumentSnapshot?
            var toUserDoc: DocumentSnapshot?
            
            for document in documents {
                if let user = try? document.data(as: User.self) {
                    if user.cards.first(where: { $0.id == fromCardId }) != nil {
                        fromUser = user
                        fromUserDoc = document
                    }
                    if user.cards.first(where: { $0.id == toCardId }) != nil {
                        toUser = user
                        toUserDoc = document
                    }
                }
            }
            
            guard var validFromUser = fromUser, var validToUser = toUser,
                  let fromUserSnapshot = fromUserDoc, let toUserSnapshot = toUserDoc else {
                completion(.failure(NSError(domain: "FirestoreService", code: -1, userInfo: [NSLocalizedDescriptionKey: "From user or to user not found for given card ids"])))
                return
            }
            
            guard var fromCard = validFromUser.cards.first(where: { $0.id == fromCardId }),
                  var toCard = validToUser.cards.first(where: { $0.id == toCardId }) else {
                completion(.failure(NSError(domain: "FirestoreService", code: -1, userInfo: [NSLocalizedDescriptionKey: "From card or to card not found in user data"])))
                return
            }
            
            guard fromCard.balance >= amount else {
                completion(.failure(NSError(domain: "FirestoreService", code: -2, userInfo: [NSLocalizedDescriptionKey: "Insufficient balance"])))
                return
            }
            
            fromCard.balance -= amount
            toCard.balance += amount
            
            if let fromCardIndex = validFromUser.cards.firstIndex(where: { $0.id == fromCard.id }) {
                validFromUser.cards[fromCardIndex] = fromCard
            }
            
            if let toCardIndex = validToUser.cards.firstIndex(where: { $0.id == toCard.id }) {
                validToUser.cards[toCardIndex] = toCard
            }
            
            let transaction = Transaction(fromUserId: validFromUser.id, toUserId: validToUser.id, fromCardId: fromCardId, toCardId: toCardId, amount: amount, timestamp: Date(), iconName: "georgia")
            
            let batch = self.db.batch()
            
            batch.setData(try! Firestore.Encoder().encode(validFromUser), forDocument: fromUserSnapshot.reference)
            batch.setData(try! Firestore.Encoder().encode(validToUser), forDocument: toUserSnapshot.reference)
            
            let transactionRef = self.db.collection("transactions").document()
            batch.setData(try! Firestore.Encoder().encode(transaction), forDocument: transactionRef)
            
            batch.commit { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    self.updateLocalTransactions(with: transaction)
                    completion(.success(()))
                }
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
