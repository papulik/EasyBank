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
    
    private init() {}
    
    func createUser(uid: String, user: User, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try db.collection("users").document(uid).setData(from: user) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
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
                completion(.success(users))
            }
        }
    }
    
    func sendMoney(fromUser: User, toUser: User, amount: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        guard fromUser.balance >= amount else {
            completion(.failure(NSError(domain: "FirestoreService", code: -2, userInfo: [NSLocalizedDescriptionKey: "Insufficient balance"])))
            return
        }
        
        let transaction = Transaction(fromUserId: fromUser.id, toUserId: toUser.id, amount: amount, timestamp: Date())
        
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
                completion(.success(()))
            }
        }
    }
}
